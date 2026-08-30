import 'package:flutter/material.dart';
import '../core/constants.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  String _selectedPlatform = 'روبیکا';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('ثبت سفارش جدید', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('پلتفرم را انتخاب کنید', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            _buildPlatformSelector(),
            const SizedBox(height: 30),
            const Text('دسته‌بندی خدمات', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            _buildDropdown('روبیکا | دنبال‌کننده روبینو'),
            const SizedBox(height: 20),
            const Text('سرویس مورد نظر', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            _buildDropdown('انتخاب کنید'),
            const SizedBox(height: 40),
            _buildOrderFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    final platforms = [
      {'name': 'آپارات', 'icon': Icons.play_circle},
      {'name': 'روبیکا', 'icon': Icons.apps},
      {'name': 'ایتا', 'icon': Icons.chat_bubble},
    ];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: platforms.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedPlatform == platforms[index]['name'];
          return GestureDetector(
            onTap: () => setState(() => _selectedPlatform = platforms[index]['name'] as String),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.white12),
              ),
              child: Row(
                children: [
                  Icon(platforms[index]['icon'] as IconData, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(platforms[index]['name'] as String, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildOrderFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E2E8C),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('ثبت سفارش', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('مبلغ قابل پرداخت', style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text('۰ تومان', style: TextStyle(color: AppColors.secondary, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
