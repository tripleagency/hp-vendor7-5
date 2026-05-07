import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_plate_vendor/core/theme/colors.dart';
import 'package:home_plate_vendor/core/theme/app_styles.dart';
import 'package:home_plate_vendor/core/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_ChatMessage> _messages = <_ChatMessage>[
    _ChatMessage(
      id: '1',
      text: 'chat_sample_message_1'.tr(),
      isMe: false,
      time: DateTime.now(),
      type: _MessageType.text,
    ),
    _ChatMessage(
      id: '2',
      text: 'chat_sample_message_2'.tr(),
      isMe: true,
      time: DateTime.now(),
      type: _MessageType.text,
    ),
  ];

  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: AppColors.gray.withOpacity(0.5),
              child: Icon(Icons.person, size: 20.sp, color: AppColors.gray),
            ),
            SizedBox(width: 8.w),
            Text('support_team'.tr(), style: AppStyles.inter18RegularBlack),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: const Divider(height: 1, color: AppColors.gray),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                return _MessageBubble(message: m);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                prefixIcon: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: AppColors.primary,
                ),
                suffixIcon: _AttachmentMenu(onPickImage: _onPickImage),
                controller: _textCtrl,
                hintText: 'type_message_hint'.tr(),
                maxLines: 1,
                borderColor: AppColors.white,
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _onSendText,
              child: Container(
                width: 56.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(Icons.send, color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _messages.add(
          _ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            isMe: true,
            time: DateTime.now(),
            type: _MessageType.image,
            file: File(file.path),
          ),
        );
      });
      _scrollToBottom();
    }
  }

  void _onSendText() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMe: true,
          time: DateTime.now(),
          type: _MessageType.text,
        ),
      );
      _textCtrl.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent + 80.h,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _AttachmentMenu extends StatelessWidget {
  final Future<void> Function() onPickImage;
  const _AttachmentMenu({required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'image') {
          await onPickImage();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'image',
          child: Row(
            children: [
              const Icon(Icons.image_outlined),
              SizedBox(width: 8.w),
              Text('image_label'.tr()),
            ],
          ),
        ),
      ],
      child: Icon(Icons.more_vert, color: AppColors.gray, size: 28.sp),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bg = isMe ? AppColors.primary : AppColors.gray;
    final textColor = isMe ? AppColors.white : Colors.black87;

    Widget bubbleChild;
    switch (message.type) {
      case _MessageType.text:
        bubbleChild = Text(
          message.text ?? '',
          style: AppStyles.inter14Regular.copyWith(color: textColor),
        );
        break;
      case _MessageType.image:
        bubbleChild = ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.file(message.file!, width: 220.w, fit: BoxFit.cover),
        );
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: message.type == _MessageType.text
                ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: message.type == _MessageType.text
                  ? bg
                  : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
                bottomLeft: Radius.circular(isMe ? 12.r : 2.r),
                bottomRight: Radius.circular(isMe ? 2.r : 12.r),
              ),
            ),
            child: bubbleChild,
          ),
          SizedBox(height: 4.h),
          Text(
            _formatTime(message.time),
            style: AppStyles.inter12Regular.copyWith(color: AppColors.gray),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final m = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? 'pm' : 'am';
    return '$h:$m $ampm';
  }
}

enum _MessageType { text, image }

class _ChatMessage {
  final String id;
  final String? text;
  final bool isMe;
  final DateTime time;
  final _MessageType type;
  final File? file;

  _ChatMessage({
    required this.id,
    this.text,
    required this.isMe,
    required this.time,
    required this.type,
    this.file,
  });
}
