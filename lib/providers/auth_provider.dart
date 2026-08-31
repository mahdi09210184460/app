import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  AppUser? _user;
  bool _isInitialized = false;

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.email == 'amin1391soltani@gmail.com'; // ایمیل ادمین
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _init();
  }

  void _init() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final Session? session = data.session;
      final User? user = session?.user;

      if (user != null) {
        _fetchUserProfile(user.id, user.userMetadata?['full_name'] ?? 'کاربر', user.email ?? '');
      } else {
        _user = null;
        _isInitialized = true;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserProfile(String uid, String name, String email) async {
    UserRole role = UserRole.user;
    if (email == 'amin1391soltani@gmail.com') {
      role = UserRole.admin;
    }

    _user = AppUser(
      id: uid,
      name: name,
      email: email,
      role: role,
    );
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> loginDirectly(String name, String email) async {
    try {
      // برای ورود مستقیم و سریع، فعلاً وضعیت کاربر را به صورت محلی تنظیم می‌کنیم
      UserRole role = UserRole.user;
      if (email == 'amin1391soltani@gmail.com') {
        role = UserRole.admin;
      }

      _user = AppUser(
        id: 'temp-id-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: role,
      );
      _isInitialized = true;
      notifyListeners();
      
      // اختیاری: می‌توانید اینجا یک ورود ناشناس به سوپابیس هم بزنید تا سشن داشته باشید
      // await _supabase.auth.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendOtp(String email, String name) async {
    try {
      // ارسال کد ورود به ایمیل (OTP)
      await _supabase.auth.signInWithOtp(
        email: email,
        data: {'full_name': name},
        shouldCreateUser: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String email, String token) async {
    try {
      await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
