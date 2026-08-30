import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../core/constants.dart';
import '../providers/wallet_provider.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context);
    final transactions = wallet.transactions.reversed.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تاریخچه تراکنش‌ها', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 60, color: Colors.white12),
                  SizedBox(height: 16),
                  Text('هنوز هیچ تراکنشی ثبت نشده است', style: TextStyle(color: Colors.white38)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final bool isCredit = tx['type'] == 'credit';
                final amount = (tx['amount'] as num).toInt();
                final date = DateTime.parse(tx['created_at']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isCredit ? Colors.green : Colors.red).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline,
                          color: isCredit ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx['description'] ?? 'تراکنش سیستمی',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              intl.DateFormat('yyyy/MM/dd HH:mm').format(date),
                              style: const TextStyle(color: Colors.white24, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isCredit ? '+' : '-'}${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ت',
                        style: TextStyle(
                          color: isCredit ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
