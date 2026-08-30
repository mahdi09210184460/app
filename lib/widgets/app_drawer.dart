import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/wallet_provider.dart';
import '../screens/lottery_screen.dart';
import '../screens/admin/admin_panel_screen.dart';
import '../screens/referral_screen.dart';
import '../screens/about_screen.dart';
import '../screens/transaction_history_screen.dart';
import '../screens/support_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _adminClickCount = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final wallet = Provider.of<WalletProvider>(context);
    final user = auth.user;

    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.cardBg),
            accountName: Text(user?.name ?? 'کاربر', style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text('موجودی: ${wallet.balance.toInt()} تومان', style: const TextStyle(color: AppColors.secondary)),
            currentAccountPicture: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white)),
          ),
          ListTile(
            leading: const Icon(Icons.add_card, color: Colors.greenAccent),
            title: const Text('شارژ کیف پول', style: TextStyle(color: Colors.white)),
            onTap: () => _showChargeDialog(context, wallet),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined, color: Colors.blueAccent),
            title: const Text('تاریخچه تراکنش‌ها', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionHistoryScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent, color: Colors.purpleAccent),
            title: const Text('پشتیبانی و تیکت‌ها', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.group_add_outlined, color: Colors.white70),
            title: const Text('کسب درآمد', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReferralScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events_outlined, color: Colors.amber),
            title: const Text('قرعه‌کشی', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LotteryScreen())),
          ),
          const Divider(color: Colors.white10),
          GestureDetector(
            onTap: () {
              _adminClickCount++;
              if (_adminClickCount >= 3) {
                _adminClickCount = 0;
                _showAdminPasswordDialog(context, user?.phoneNumber);
              }
            },
            child: const ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white70),
              title: Text('درباره دیدینو', style: TextStyle(color: Colors.white)),
            ),
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('خروج', style: TextStyle(color: Colors.red)),
            onTap: () => auth.logout(),
          ),
        ],
      ),
    );
  }

  void _showAdminPasswordDialog(BuildContext context, String? phone) {
    final passwordC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('ورود امنیتی', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: passwordC,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'رمز عبور مدیریت', labelStyle: TextStyle(color: Colors.white38)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (phone == '09927891608' && passwordC.text == 'amin1391soltani') {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen()));
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('دسترسی غیرمجاز!')));
              }
            },
            child: const Text('تایید'),
          ),
        ],
      ),
    );
  }

  void _showChargeDialog(BuildContext context, WalletProvider wallet) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('شارژ کیف پول', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'مبلغ به تومان', hintStyle: TextStyle(color: Colors.white24)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                await wallet.addBalance(amount, 'شارژ مستقیم حساب');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کیف پول با موفقیت شارژ شد ✅')));
              }
            },
            child: const Text('پرداخت'),
          ),
        ],
      ),
    );
  }
}
