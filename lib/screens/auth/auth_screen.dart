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
  bool _isLoading = false;

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
                const Icon(Icons.login_rounded, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),
                const Text(
                  'ورود به برنامه',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'لطفاً اطلاعات خود را برای ورود وارد کنید',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 40),
                _buildTextField(_nameController, 'نام کامل', Icons.person_outline, TextInputType.name),
                const SizedBox(height: 20),
                _buildTextField(_emailController, 'آدرس ایمیل', Icons.alternate_email, TextInputType.emailAddress),
                const SizedBox(height: 40),
                _isLoading 
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          'ورود مستقیم',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
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

  void _handleLogin() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً نام و ایمیل را وارد کنید')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).loginDirectly(
        _nameController.text, 
        _emailController.text
      );
      // پس از متد loginDirectly، چون notifyListeners صدا زده می‌شود،
      // MaterialApp در main.dart متوجه شده و HomeScreen را نشان می‌دهد.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا در ورود: $e')));
    }
    setState(() => _isLoading = false);
  }
}
