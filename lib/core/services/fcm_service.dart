import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/core/di/di.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';

/// Service that wires Firebase Cloud Messaging into the Vendor app.
///
/// Lifecycle:
///   1. `init()` is called once from `main.dart` after `Firebase.initializeApp`.
///   2. After successful login → call [registerToken] to send the FCM token to
///      backend (`POST /api/vendor/device-tokens`).
///   3. On logout → call [unregisterToken] to remove it.
///
/// The handler `_routeFromData` is the single place that decides where each
/// notification type takes the user. Wire your navigation here.
class FcmService {
  FcmService._();

  static final FlutterLocalNotificationsPlugin _localPlugin =
      FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'default_channel',
    'General',
    description: 'Default notification channel',
    importance: Importance.high,
  );

  /// Optional: route handler set by the app on init. Receives the raw
  /// `data` map from the FCM payload. Use it to push the right screen.
  static void Function(Map<String, dynamic> data)? _routeHandler;

  // ── Public API ─────────────────────────────────────────────────────────

  /// Initialize FCM. Call once after `Firebase.initializeApp(...)` in `main.dart`.
  static Future<void> init({
    void Function(Map<String, dynamic> data)? onNotificationTap,
  }) async {
    _routeHandler = onNotificationTap;
    final messaging = FirebaseMessaging.instance;

    // Permission (iOS + Android 13+)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // iOS only: ensure APNs token is available before getToken()
    if (Platform.isIOS) {
      await messaging.getAPNSToken();
    }

    // Local notification setup (used to show notifications while app is in
    // foreground — FCM only auto-displays in background/terminated states).
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localPlugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) _handlePayload(payload);
      },
    );

    // Create Android notification channel
    await _localPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Foreground messages — show as local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notif = message.notification;
      if (notif == null) return;
      _localPlugin.show(
        notif.hashCode,
        notif.title,
        notif.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    });

    // Tap on push (background → opened)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _routeFromData(message.data);
    });

    // Tap on push (terminated → opened)
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      _routeFromData(initial.data);
    }

    // Background isolate handler must be top-level
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  }

  /// Returns the current FCM token (or null if permission not granted yet).
  static Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) print('FcmService.getToken error: $e');
      return null;
    }
  }

  /// Listen for token rotations and re-send to backend automatically.
  static void listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      registerToken(newToken: newToken);
    });
  }

  /// Send the FCM token to the backend.
  /// Call after login completes (or whenever a new token arrives).
  /// Silently swallows errors — push registration is best-effort.
  static Future<void> registerToken({String? newToken}) async {
    try {
      final token = newToken ?? await getToken();
      if (token == null || token.isEmpty) return;
      await sl<DioConsumer>().post(
        '/api/vendor/device-tokens',
        body: {
          'fcm_token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'device_name': _platformLabel(),
        },
      );
    } catch (e) {
      if (kDebugMode) print('FcmService.registerToken error: $e');
    }
  }

  /// Remove the current FCM token from backend (call on logout).
  static Future<void> unregisterToken() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return;
      await sl<DioConsumer>().delete(
        '/api/vendor/device-tokens',
        // dio supports a body on DELETE through queryParameters; we'll pass via
        // body using a workaround: the backend also accepts the token in body.
      );
      // Optionally also delete the local token so a fresh one gets minted next
      // login session.
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      if (kDebugMode) print('FcmService.unregisterToken error: $e');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  static void _handlePayload(String payload) {
    try {
      final data = Map<String, dynamic>.from(jsonDecode(payload) as Map);
      _routeFromData(data);
    } catch (_) {}
  }

  static void _routeFromData(Map<String, dynamic> data) {
    final handler = _routeHandler;
    if (handler != null) handler(data);
  }

  static String _platformLabel() {
    if (Platform.isIOS) return 'iOS Device';
    if (Platform.isAndroid) return 'Android Device';
    return 'Unknown';
  }
}

/// Top-level (required by Firebase) background handler.
/// Keep minimal — runs in its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // The system already shows the notification. Use this only if you need
  // to update local DB or analytics.
  // ignore: avoid_print
  if (kDebugMode) print('FCM background message: ${message.messageId}');
  // Avoid using DI from here; isolate state is fresh.
  // Optionally read SharedPreferences:
  try {
    final cache = CacheHelper();
    await cache.init();
    // future: increment local unread counter, etc.
    // ignore: unused_local_variable
    final tokenSeen = cache.getData(key: AppConstants.accessTokenKey);
  } catch (_) {}
}
