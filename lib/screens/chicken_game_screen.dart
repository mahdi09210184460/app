import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/wallet_provider.dart';

class ChickenGameScreen extends StatefulWidget {
  const ChickenGameScreen({super.key});

  @override
  State<ChickenGameScreen> createState() => _ChickenGameScreenState();
}

class _ChickenGameScreenState extends State<ChickenGameScreen> with TickerProviderStateMixin {
  bool _gameStarted = false;
  double _chickenY = 0.8;
  int _jumps = 0;
  double _currentEarnings = 0;
  List<double> _carX = [-1.0, 1.5, -0.5];
  List<double> _carY = [0.2, 0.4, 0.6];
  late Timer _timer;
  bool _isGameOver = false;

  void _startGame() async {
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    if (wallet.balance < 50000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('موجودی کافی نیست (۵۰,۰۰۰ تومان نیاز است)')));
      return;
    }

    await wallet.deductBalance(50000, 'ورودی بازی مرغ');
    setState(() {
      _gameStarted = true;
      _jumps = 0;
      _currentEarnings = 50000;
      _isGameOver = false;
      _chickenY = 0.8;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (int i = 0; i < _carX.length; i++) {
          _carX[i] += (0.02 + (_jumps > 5 ? 0.015 : 0)); // سخت شدن بعد از ۵ پرش
          if (_carX[i] > 1.2) _carX[i] = -0.2;

          // تشخیص برخورد
          if ((_carX[i] - 0.5).abs() < 0.1 && (_carY[i] - _chickenY).abs() < 0.1) {
            _gameOver();
          }
        }
      });
    });
  }

  void _jump() {
    if (!_gameStarted || _isGameOver) return;
    setState(() {
      _jumps++;
      _currentEarnings += 500;
      _chickenY -= 0.1;
      if (_chickenY < 0.1) _chickenY = 0.8; // ریست موقعیت برای بی نهایت شدن جاده
    });
  }

  void _gameOver() {
    _timer.cancel();
    setState(() {
      _isGameOver = true;
      _gameStarted = false;
    });
    _showResultDialog(false);
  }

  void _collectMoney() async {
    if (_jumps < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('باید حداقل ۵ بار بپرید!')));
      return;
    }
    _timer.cancel();
    final wallet = Provider.of<WalletProvider>(context, listen: false);
    await wallet.addBalance(_currentEarnings, 'جایزه بازی مرغ');
    _showResultDialog(true);
  }

  void _showResultDialog(bool win) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(win ? '🥳 تبریک!' : '😭 باختید!', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(win ? '💰 مبلغ ${(_currentEarnings).toInt()} تومان به کیف پول اضافه شد' : 'تمام پول شما سوخت!',
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Text(win ? '😂' : '😢', style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('فهمیدم')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_gameStarted) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('فرار مرغ از جاده'), backgroundColor: AppColors.background),
      body: Column(
        children: [
          _buildInfoBar(),
          Expanded(
            child: GestureDetector(
              onTap: _jump,
              child: Stack(
                children: [
                  _buildRoad(),
                  ...List.generate(_carX.length, (i) => _buildCar(_carX[i], _carY[i])),
                  _buildChicken(),
                ],
              ),
            ),
          ),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.cardBg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('پرش: $_jumps', style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text('مبلغ فعلی: ${_currentEarnings.toInt()} ت', style: const TextStyle(color: AppColors.secondary, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRoad() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: NetworkImage('https://img.freepik.com/free-vector/road-top-view-asphalt-highway-street_107791-2394.jpg'), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCar(double x, double y) {
    return AnimatedAlign(
      alignment: Alignment(x * 2 - 1, y * 2 - 1),
      duration: const Duration(milliseconds: 50),
      child: const Icon(Icons.directions_car, color: Colors.red, size: 50),
    );
  }

  Widget _buildChicken() {
    return AnimatedAlign(
      alignment: Alignment(0, _chickenY * 2 - 1),
      duration: const Duration(milliseconds: 200),
      child: const Icon(Icons.cruelty_free, color: Colors.yellow, size: 60),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!_gameStarted)
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text('شروع (۵۰,۰۰۰ ت)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          if (_gameStarted)
            ElevatedButton(
              onPressed: _collectMoney,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text('برداشت پول', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }
}
