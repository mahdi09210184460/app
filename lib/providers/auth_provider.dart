import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  AppUser? _user;
  bool _isInitialized = false;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.role == UserRole.admin;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _init();
  }

  void _init() {
    // گوش دادن به تغییرات وضعیت احراز هویت در سوپابیس
    _supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      final User? user = session?.user;

      if (user != null) {
        _fetchUserProfile(user.id, user.userMetadata?['full_name'] ?? 'کاربر', user.phone ?? '');
      } else {
        _user = null;
        _isInitialized = true;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserProfile(String uid, String name, String phone) async {
    // در اینجا می‌توان پروفایل تکمیلی را از جدول profiles در دیتابیس خواند
    // فعلاً با اطلاعات سشن کاربر را می‌سازیم
    UserRole role = UserRole.user;
    if (phone == '09927891608' || phone.contains('9927891608')) {
      role = UserRole.admin;
    }

    _user = AppUser(
      id: uid,
      name: name,
      phoneNumber: phone,
      role: role,
    );
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> registerAndLogin(String name, String phone) async {
    try {
      // استفاده از OTP شماره موبایل سوپابیس
      // توجه: در حالت توسعه، اگر سرویس پیامکی فعال نباشد، سوپابیس لاگ می‌اندازد
      await _supabase.auth.signInWithOtp(
        phone: phone,
        data: {'full_name': name},
      );
      
      // برای این پروژه، چون می‌خواهیم فعلاً مستقیم وارد شویم (بدون تایید واقعی OTP در مرحله تست)
      // اگر در پنل سوپابیس تیک "Confirm Phone" غیرفعال باشد، ورود مستقیم انجام می‌شود.
      // در غیر این صورت کاربر باید کد را در مرحله بعد وارد کند.
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
