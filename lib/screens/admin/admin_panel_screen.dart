import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/admin_provider.dart';
import '../../providers/service_provider.dart';
import '../../models/order_model.dart';
import '../../core/constants.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);
    final serviceProv = Provider.of<ServiceProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('مدیریت دیدینو'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'سفارشات'),
            Tab(text: 'تیکت‌ها'),
            Tab(text: 'درگاه‌ها'),
            Tab(text: 'قرعه‌کشی'),
            Tab(text: 'دسته‌ها'),
            Tab(text: 'سرویس‌ها'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersTab(adminProv),
          _buildTicketsTab(adminProv),
          _buildGatewaysTab(adminProv),
          _buildLotteryTab(adminProv),
          _buildCategoriesTab(serviceProv),
          _buildServicesTab(serviceProv),
        ],
      ),
    );
  }

  Widget _buildTicketsTab(AdminProvider admin) {
    final tickets = admin.tickets;
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final t = tickets[index];
        return Card(
          color: AppColors.cardBg,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(t['subject'] ?? '', style: const TextStyle(color: Colors.white)),
            subtitle: Text(t['message'] ?? '', style: const TextStyle(color: Colors.white54), maxLines: 1),
            trailing: Icon(t['status'] == 'open' ? Icons.mark_email_unread : Icons.check_circle, 
                          color: t['status'] == 'open' ? Colors.orange : Colors.green),
            onTap: () => _showReplyDialog(context, admin, t),
          ),
        );
      },
    );
  }

  void _showReplyDialog(BuildContext context, AdminProvider admin, Map<String, dynamic> ticket) {
    final replyC = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('پاسخ به تیکت', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('پیام کاربر: ${ticket['message']}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            TextField(controller: replyC, maxLines: 3, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'پاسخ شما')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('انصراف')),
          ElevatedButton(
            onPressed: () {
              admin.replyTicket(ticket['id'], replyC.text);
              Navigator.pop(context);
            },
            child: const Text('ارسال پاسخ'),
          ),
        ],
      ),
    );
  }

  // سایر تب‌ها
  Widget _buildOrdersTab(AdminProvider admin) => ListView.builder(
    itemCount: admin.allOrders.length, 
    itemBuilder: (context, index) {
      final o = admin.allOrders[index];
      return ListTile(
        title: Text(o.serviceTitle, style: const TextStyle(color: Colors.white)),
        subtitle: Text(o.link, style: const TextStyle(color: Colors.white54), overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          onPressed: () => admin.updateOrderStatus(o.id, OrderStatus.completed),
        ),
      );
    }
  );

  Widget _buildGatewaysTab(AdminProvider admin) => ListView.builder(itemCount: admin.allGateways.length, itemBuilder: (context, index) => ListTile(title: Text(admin.allGateways[index].name, style: const TextStyle(color: Colors.white))));

  Widget _buildLotteryTab(AdminProvider admin) => Column(children: [
    ListTile(title: const Text('افزودن قرعه‌کشی', style: TextStyle(color: Colors.white)), leading: const Icon(Icons.add, color: Colors.white), onTap: () => _showLotteryDialog(context, admin)),
    Expanded(child: ListView.builder(itemCount: admin.lotteries.length, itemBuilder: (context, index) => ListTile(title: Text(admin.lotteries[index]['title'], style: const TextStyle(color: Colors.white))))),
  ]);

  void _showLotteryDialog(BuildContext context, AdminProvider admin) {
    final titleC = TextEditingController();
    final costC = TextEditingController();
    String? bannerUrl;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setS) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        title: const Text('قرعه‌کشی جدید', style: TextStyle(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextButton.icon(onPressed: () async {
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              final url = await admin.uploadImage(File(image.path));
              setS(() => bannerUrl = url);
            }
          }, icon: const Icon(Icons.image), label: const Text('انتخاب عکس')),
          TextField(controller: titleC, decoration: const InputDecoration(labelText: 'عنوان')),
          TextField(controller: costC, decoration: const InputDecoration(labelText: 'هزینه')),
        ]),
        actions: [ElevatedButton(onPressed: () {
          admin.addOrUpdateLottery({'title': titleC.text, 'cost': double.parse(costC.text), 'banner_url': bannerUrl, 'is_active': true});
          Navigator.pop(context);
        }, child: const Text('ذخیره'))],
      )),
    );
  }

  Widget _buildCategoriesTab(ServiceProvider prov) => ListView.builder(itemCount: prov.categories.length, itemBuilder: (context, index) => ListTile(title: Text(prov.categories[index].title, style: const TextStyle(color: Colors.white))));
  Widget _buildServicesTab(ServiceProvider prov) => ListView.builder(itemCount: prov.allServices.length, itemBuilder: (context, index) => ListTile(title: Text(prov.allServices[index].title, style: const TextStyle(color: Colors.white))));
}
