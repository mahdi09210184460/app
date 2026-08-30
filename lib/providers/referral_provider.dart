import 'package:flutter/material.dart';

class ReferralProvider with ChangeNotifier {
  String _referralCode = "DID-88542"; // کد معرف کاربر
  int _invitedCount = 12;
  double _totalEarnings = 15000;

  String get referralCode => _referralCode;
  int get invitedCount => _invitedCount;
  double get totalEarnings => _totalEarnings;

  // منطق محاسبه پاداش دعوت
  void inviteFriend() {
    _invitedCount++;
    _totalEarnings += 1000;
    notifyListeners();
  }
}
