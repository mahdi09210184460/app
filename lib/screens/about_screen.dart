import 'package:flutter/material.dart';
import '../core/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('درباره دیدینو'), backgroundColor: AppColors.background, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.rocket_launch, size: 80, color: AppColors.primary),
            const SizedBox(height: 20),
            const Text(
              'تیم مدیریتی دیدینو',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(15)),
              child: const Text(
                AppStrings.aboutDescription,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white70, height: 1.8),
              ),
            ),
            const SizedBox(height: 30),
            const Text('پشتیبانی:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('آیدی پشتیبانی در برنامه: @Didino_Support', style: TextStyle(color: AppColors.secondary)),
            const SizedBox(height: 40),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _KeywordChip('خرید فالوور'),
                _KeywordChip('خرید لایک'),
                _KeywordChip('خدمات آپارات'),
                _KeywordChip('روبیکا'),
                _KeywordChip('ایتا'),
                _KeywordChip('ممبر تلگرام'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;
  const _KeywordChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
    );
  }
}
