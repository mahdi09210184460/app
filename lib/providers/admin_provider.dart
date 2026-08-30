import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/gateway_model.dart';

class AdminProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<AppOrder> _allOrders = [];
  List<PaymentGateway> _gateways = [];
  List<Map<String, dynamic>> _lotteries = [];
  List<Map<String, dynamic>> _winners = [];

  List<Map<String, dynamic>> _tickets = [];

  List<AppOrder> get allOrders => _allOrders;
  List<PaymentGateway> get allGateways => _gateways;
  List<PaymentGateway> get activeGateways => _gateways.where((g) => g.isActive).toList();
  List<Map<String, dynamic>> get lotteries => _lotteries;
  List<Map<String, dynamic>> get winners => _winners;
  List<Map<String, dynamic>> get tickets => _tickets;

  AdminProvider() {
    fetchOrders();
    fetchGateways();
    fetchLotteries();
    fetchWinners();
    fetchTickets();
  }

  // --- مدیریت تیکت‌ها ---
  Future<void> fetchTickets() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    
    var query = _supabase.from('tickets').select();
    // اگر مدیر نیست، فقط تیکت‌های خودش را ببیند
    if (user.phone != '09927891608') {
      query = query.eq('user_id', user.id);
    }
    
    final data = await query.order('created_at');
    _tickets = List<Map<String, dynamic>>.from(data);
    notifyListeners();
  }

  Future<void> sendTicket(String subject, String message) async {
    await _supabase.from('tickets').insert({
      'user_id': _supabase.auth.currentUser?.id,
      'subject': subject,
      'message': message,
    });
    fetchTickets();
  }

  Future<void> replyTicket(String ticketId, String reply) async {
    await _supabase.from('tickets').update({
      'reply': reply,
      'status': 'closed',
    }).eq('id', ticketId);
    fetchTickets();
  }

  // --- مدیریت قرعه‌کشی ---
  Future<void> fetchLotteries() async {
    final data = await _supabase.from('lotteries').select().order('created_at');
    _lotteries = List<Map<String, dynamic>>.from(data);
    notifyListeners();
  }

  Future<void> fetchWinners() async {
    final data = await _supabase.from('winners').select().order('winner_date');
    _winners = List<Map<String, dynamic>>.from(data);
    notifyListeners();
  }

  Future<void> addOrUpdateLottery(Map<String, dynamic> lottery) async {
    await _supabase.from('lotteries').upsert(lottery);
    fetchLotteries();
  }

  // --- آپلود تصویر به Supabase Storage ---
  Future<String?> uploadImage(File file) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';
      await _supabase.storage.from('media').upload(path, file);
      return _supabase.storage.from('media').getPublicUrl(path);
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  // --- بقیه متدهای قبلی ---
  Future<void> fetchOrders() async {
    final data = await _supabase.from('orders').select().order('created_at', ascending: false);
    _allOrders = (data as List).map((o) => AppOrder(
      id: o['id'], serviceTitle: o['service_title'], link: o['link'], quantity: o['quantity'],
      totalPrice: (o['total_price'] as num).toDouble(), date: DateTime.parse(o['created_at']),
      status: OrderStatus.values.firstWhere((e) => e.name == o['status'], orElse: () => OrderStatus.pending),
    )).toList();
    notifyListeners();
  }

  Future<void> fetchGateways() async {
    final data = await _supabase.from('gateways').select();
    _gateways = (data as List).map((g) => PaymentGateway(id: g['id'], name: g['name'], url: g['url'], isActive: g['is_active'])).toList();
    notifyListeners();
  }

  Future<void> addOrder(AppOrder order) async {
    await _supabase.from('orders').insert({
      'user_id': _supabase.auth.currentUser?.id, 'service_title': order.serviceTitle,
      'link': order.link, 'quantity': order.quantity, 'total_price': order.totalPrice, 'status': 'pending',
    });
    fetchOrders();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await _supabase.from('orders').update({'status': newStatus.name}).eq('id', orderId);
    fetchOrders();
  }

  Future<void> addOrUpdateGateway(String id, String name, String url) async {
    final payload = {'name': name, 'url': url};
    if (id.isEmpty) { await _supabase.from('gateways').insert(payload); }
    else { await _supabase.from('gateways').update(payload).eq('id', id); }
    fetchGateways();
  }

  Future<void> toggleGatewayStatus(String id) async {
    final g = _gateways.firstWhere((element) => element.id == id);
    await _supabase.from('gateways').update({'is_active': !g.isActive}).eq('id', id);
    fetchGateways();
  }
}
