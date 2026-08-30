import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/admin_provider.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);
    final tickets = adminProv.tickets.reversed.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('پشتیبانی و تیکت‌ها', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: tickets.isEmpty
                ? const Center(child: Text('هنوز هیچ تیکتی ثبت نکردید', style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final t = tickets[index];
                      return Card(
                        color: AppColors.cardBg,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          title: Text(t['subject'] ?? 'بدون موضوع', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(t['status'] == 'open' ? 'در انتظار پاسخ' : 'پاسخ داده شده', 
                                       style: TextStyle(color: t['status'] == 'open' ? Colors.orange : Colors.green, fontSize: 12)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('پیام شما:', style: TextStyle(color: Colors.white54, fontSize: 11)),
                                  Text(t['message'] ?? '', style: const TextStyle(color: Colors.white)),
                                  if (t['reply'] != null) ...[
                                    const Divider(color: Colors.white10, height: 24),
                                    const Text('پاسخ مدیریت:', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text(t['reply'], style: const TextStyle(color: Colors.white70)),
                                  ],
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showNewTicketDialog(context, adminProv),
              icon: const Icon(Icons.add_comment_outlined),
              label: const Text('ارسال تیکت جدید'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewTicketDialog(BuildContext context, AdminProvider prov) {
    final subjectC = TextEditingController();
    final messageC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('تیکت جدید', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: subjectC, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'موضوع', labelStyle: TextStyle(color: Colors.white38))),
            TextField(controller: messageC, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'پیام شما', labelStyle: TextStyle(color: Colors.white38))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () {
              if (subjectC.text.isNotEmpty && messageC.text.isNotEmpty) {
                prov.sendTicket(subjectC.text, messageC.text);
                Navigator.pop(context);
              }
            },
            child: const Text('ارسال'),
          ),
        ],
      ),
    );
  }
}
