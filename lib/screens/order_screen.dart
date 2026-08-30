import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../models/service_model.dart';
import '../models/order_model.dart';
import '../providers/admin_provider.dart';
import '../providers/wallet_provider.dart';
import '../models/gateway_model.dart';

class OrderScreen extends StatefulWidget {
  final SocialService service;
  const OrderScreen({super.key, required this.service});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _linkController = TextEditingController();
  final _quantityController = TextEditingController();
  double _totalPrice = 0;
  String _paymentMethod = 'wallet'; // 'wallet' or 'direct'
  PaymentGateway? _selectedGateway;

  void _calculatePrice(String value) {
    if (value.isEmpty) {
      setState(() => _totalPrice = 0);
      return;
    }
    final quantity = int.tryParse(value) ?? 0;
    setState(() {
      _totalPrice = (quantity / 1000) * widget.service.pricePer1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminProv = Provider.of<AdminProvider>(context);
    final walletProv = Provider.of<WalletProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('ثبت سفارش'), backgroundColor: AppColors.background),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceInfoCard(),
            const SizedBox(height: 24),
            _buildInputs(),
            const SizedBox(height: 24),
            const Text('روش پرداخت:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            _buildPaymentMethodSelector(walletProv.balance),
            if (_paymentMethod == 'direct') _buildGatewaySelector(adminProv.activeGateways),
            const SizedBox(height: 32),
            _buildOrderButton(adminProv, walletProv),
          ],
        ),
      ),
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        TextField(
          controller: _linkController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'لینک هدف (پیج یا پست)',
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: AppColors.cardBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          onChanged: _calculatePrice,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'تعداد مورد نظر',
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: AppColors.cardBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector(double balance) {
    return Column(
      children: [
        RadioListTile(
          title: Text('کیف پول (موجودی: ${balance.toInt()} ت)', style: const TextStyle(color: Colors.white)),
          value: 'wallet',
          groupValue: _paymentMethod,
          onChanged: (val) => setState(() => _paymentMethod = val.toString()),
        ),
        RadioListTile(
          title: const Text('پرداخت مستقیم بانکی', style: TextStyle(color: Colors.white)),
          value: 'direct',
          groupValue: _paymentMethod,
          onChanged: (val) => setState(() => _paymentMethod = val.toString()),
        ),
      ],
    );
  }

  Widget _buildGatewaySelector(List<PaymentGateway> gateways) {
    return Column(
      children: gateways.map((g) => RadioListTile<PaymentGateway>(
        title: Text(g.name, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        value: g,
        groupValue: _selectedGateway,
        onChanged: (val) => setState(() => _selectedGateway = val),
      )).toList(),
    );
  }

  Widget _buildOrderButton(AdminProvider admin, WalletProvider wallet) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          if (_totalPrice <= 0 || _linkController.text.isEmpty) return;

          if (_paymentMethod == 'wallet') {
            bool success = await wallet.deductBalance(_totalPrice, 'خرید سرویس: ${widget.service.title}');
            if (!success) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('موجودی کیف پول کافی نیست!')));
              return;
            }
          } else {
            if (_selectedGateway == null) return;
            await launchUrl(Uri.parse(_selectedGateway!.url), mode: LaunchMode.externalApplication);
          }

          // ثبت سفارش
          await admin.addOrder(AppOrder(
            id: '', serviceTitle: widget.service.title, link: _linkController.text,
            quantity: int.parse(_quantityController.text), totalPrice: _totalPrice,
            date: DateTime.now(), status: OrderStatus.pending,
          ));

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('سفارش با موفقیت ثبت شد ✅')));
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text('تایید و پرداخت (${_totalPrice.toInt()} تومان)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildServiceInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.service.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(widget.service.description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}
