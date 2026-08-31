import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _showOtpField = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Icon(Icons.email_outlined, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),
                Text(
                  _showOtpField ? 'تایید کد' : 'ورود با ایمیل',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  _showOtpField 
                      ? 'کد ۶ رقمی به ایمیل ${_emailController.text} ارسال شد'
                      : 'کد ورود به ایمیل شما ارسال خواهد شد',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 40),
                if (!_showOtpField) ...[
                  _buildTextField(_nameController, 'نام کامل', Icons.person_outline, TextInputType.name),
                  const SizedBox(height: 20),
                  _buildTextField(_emailController, 'آدرس ایمیل (Gmail)', Icons.alternate_email, TextInputType.emailAddress),
                ] else ...[
                  _buildTextField(_otpController, 'کد تایید', Icons.lock_outline, TextInputType.number),
                ],
                const SizedBox(height: 40),
                _isLoading 
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _showOtpField ? _handleVerifyOtp : _handleSendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(
                              _showOtpField ? 'تایید و ورود' : 'ارسال کد ورود',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        if (_showOtpField) 
                          TextButton(
                            onPressed: () => setState(() => _showOtpField = false),
                            child: const Text('تغییر ایمیل', style: TextStyle(color: AppColors.primary)),
                          ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, TextInputType type) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  void _handleSendOtp() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً یک ایمیل معتبر وارد کنید')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).sendOtp(_emailController.text, _nameController.text);
      setState(() => _showOtpField = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کد تایید ارسال شد 📧')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e')));
    }
    setState(() => _isLoading = false);
  }

  void _handleVerifyOtp() async {
    if (_otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً کد ۶ رقمی را وارد کنید')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).verifyOtp(_emailController.text, _otpController.text);
      // پس از تایید موفق، AuthProvider وضعیت را تغییر می‌دهد و main.dart کاربر را به HomeScreen می‌برد
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('کد نامعتبر است یا منقضی شده: $e')));
    }
    setState(() => _isLoading = false);
  }
}
