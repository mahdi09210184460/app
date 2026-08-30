import 'package:flutter/material.dart';
import '../core/constants.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('سفارشات', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'شناسه سفارش، لینک یا نام سرویس...',
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.white24),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) => _buildOrderCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['همه', 'در انتظار', 'در حال انجام', 'تکمیل'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: index == 3 ? Colors.green.withOpacity(0.2) : AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: index == 3 ? Colors.green : Colors.white12),
          ),
          child: Center(
            child: Text(
              filters[index],
              style: TextStyle(color: index == 3 ? Colors.green : Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Text('تکمیل شده', style: TextStyle(color: Colors.green, fontSize: 10)),
              ),
              const Text('# 1210', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '3998 - فالوور روبینو ویژه خانم‌ها [پایداری تضمین شده]',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
            child: const Row(
              children: [
                Icon(Icons.link, color: Colors.blue, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('https://rubika.ir/ssimooncoom', style: TextStyle(color: Colors.blue, fontSize: 11))),
                Icon(Icons.copy, color: Colors.white24, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem(Icons.shopping_bag_outlined, 'تعداد', '500'),
              _infoItem(Icons.payments_outlined, 'هزینه', '14,880 تومان'),
              _infoItem(Icons.calendar_month_outlined, 'تاریخ', '12:38 1404/10/07'),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.message_outlined, size: 16, color: Colors.purpleAccent),
              label: const Text('ارسال تیکت', style: TextStyle(color: Colors.purpleAccent, fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(children: [Icon(icon, size: 12, color: Colors.white24), const SizedBox(width: 4), Text(label, style: const TextStyle(color: Colors.white24, fontSize: 10))]),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
