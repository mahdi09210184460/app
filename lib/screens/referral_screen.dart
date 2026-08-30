import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/referral_provider.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final refProv = Provider.of<ReferralProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('دعوت و کسب درآمد'), backgroundColor: AppColors.background, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildHeaderCard(refProv),
            const SizedBox(height: 30),
            _buildCommissionInfo(),
            const SizedBox(height: 30),
            _buildReferralCodeCard(refProv.referralCode),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('اشتراک‌گذاری لینک دعوت', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ReferralProvider prov) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF8E88FF), Color(0xFF6C63FF)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('تعداد دعوت‌ها', prov.invitedCount.toString()),
          Container(width: 1, height: 40, color: Colors.white24),
          _statItem('درآمد شما', '${prov.totalEarnings.toInt()} ت'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildCommissionInfo() {
    return Column(
      children: [
        _infoRow(Icons.card_giftcard, '۱۰۰۰ تومان هدیه به ازای هر دعوت'),
        const SizedBox(height: 12),
        _infoRow(Icons.percent, '۵٪ پورسانت از هر شارژ زیرمجموعه'),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildReferralCodeCard(String code) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          const Text('کد معرف اختصاصی شما:', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(code, style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(width: 16),
                const Icon(Icons.copy, color: Colors.white38, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
