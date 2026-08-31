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
                const Icon(Icons.email_outlined, size: 80, color: AppColors.primary),
                const SizedBox(height: 24),
                const Text('ورود با ایمیل', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('لینک ورود به ایمیل شما ارسال خواهد شد', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 13)),
                const SizedBox(height: 40),
                _buildTextField(_nameController, 'نام کامل', Icons.person_outline, TextInputType.name),
                const SizedBox(height: 20),
                _buildTextField(_emailController, 'آدرس ایمیل (Gmail)', Icons.alternate_email, TextInputType.emailAddress),
                const SizedBox(height: 40),
                _isLoading 
                  ? const CircularProgressIndicator(color: AppColors.primary)
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _handleAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('ارسال لینک ورود', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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

  void _handleAuth() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً یک ایمیل معتبر وارد کنید')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).registerAndLogin(_nameController.text, _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لینک ورود ارسال شد. ایمیل خود را چک کنید 📧')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e')));
    }
    setState(() => _isLoading = false);
  }
}
