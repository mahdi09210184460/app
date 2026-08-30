import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalletProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  double _balance = 0;
  List<Map<String, dynamic>> _transactions = [];

  double get balance => _balance;
  List<Map<String, dynamic>> get transactions => _transactions;

  WalletProvider() {
    fetchBalance();
    fetchTransactions();
  }

  Future<void> fetchBalance() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      final data = await _supabase.from('profiles').select('balance').eq('id', user.id).single();
      _balance = (data['balance'] as num).toDouble();
      notifyListeners();
    } catch (e) {
      debugPrint("Error balance: $e");
    }
  }

  Future<void> fetchTransactions() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      final data = await _supabase.from('transactions').select().eq('user_id', user.id).order('created_at');
      _transactions = List<Map<String, dynamic>>.from(data);
      notifyListeners();
    } catch (e) {
      debugPrint("Error transactions: $e");
    }
  }

  Future<void> addBalance(double amount, String desc) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final newBalance = _balance + amount;
    await _supabase.from('profiles').update({'balance': newBalance}).eq('id', user.id);
    
    // ثبت تراکنش
    await _supabase.from('transactions').insert({
      'user_id': user.id,
      'amount': amount,
      'description': desc,
      'type': 'credit'
    });
    
    _balance = newBalance;
    fetchTransactions();
  }

  Future<bool> deductBalance(double amount, String desc) async {
    if (_balance < amount) return false;
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final newBalance = _balance - amount;
    await _supabase.from('profiles').update({'balance': newBalance}).eq('id', user.id);
    
    // ثبت تراکنش
    await _supabase.from('transactions').insert({
      'user_id': user.id,
      'amount': amount,
      'description': desc,
      'type': 'debit'
    });
    
    _balance = newBalance;
    fetchTransactions();
    return true;
  }
}
