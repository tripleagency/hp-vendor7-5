import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddressProvider extends ChangeNotifier {
  final List<Map<String, String>> _addresses = [];

  List<Map<String, String>> get addresses => _addresses;

  void addAddress(Map<String, String> newAddress) {
    _addresses.add(newAddress);
    notifyListeners();
  }

  void removeAddress(int index) {
    _addresses.removeAt(index);
    notifyListeners();
  }

  void updateAddress(int index, Map<String, String> updatedAddress) {
    _addresses[index] = updatedAddress;
    notifyListeners();
  }

  void clearAddresses() {
    _addresses.clear();
    notifyListeners();
  }
}
