import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import 'chicken_game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const Icon(Icons.notifications_none, color: Colors.white),
        title: Column(
          children: [
            Text('خوش آمدید 👋', style: TextStyle(fontSize: 12, color: Colors.amber.shade600)),
            Text(user?.name ?? 'کاربر مهمان', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        centerTitle: true,
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بخش استوری‌ها (خدمات ویژه)
          _buildStories(),
          const SizedBox(height: 20),
          // بنر تبلیغاتی (مشابه کپ‌کات)
          _buildPromoBanner(),
          const SizedBox(height: 24),
          // بخش بازی‌ها
          const Text(
            'بازی و کسب درآمد 🎮',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildGamesSection(context),
          const SizedBox(height: 24),
          const Text(
            'خدمات شبکه‌های اجتماعی',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildServiceGrid(),
        ],
      ),
    );
  }

  Widget _buildGamesSection(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChickenGameScreen())),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [Color(0xFFFF9F43), Color(0xFFFF5E3A)]),
        ),
        child: Stack(
          children: [
            const Positioned(
              right: 20,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('بازی مرغ از خیابان', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('هر پرش ۵۰۰ تومان جایزه!', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            Positioned(
              left: 20,
              bottom: 10,
              child: Image.network('https://cdn-icons-png.flaticon.com/512/2632/2632839.png', height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStories() {
    final stories = [
      {'name': 'کانال تلگرام', 'icon': Icons.telegram, 'color': Colors.blue},
      {'name': 'اکانت کپ‌کات', 'icon': Icons.video_library, 'color': Colors.purple},
    ];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.cardBg,
                  child: Icon(stories[index]['icon'] as IconData, color: stories[index]['color'] as Color),
                ),
              ),
              const SizedBox(height: 4),
              Text(stories[index]['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x200'), // اینجا باید تصویر کپ کات قرار گیرد
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('اشتراک حرفه‌ای کپ‌کات پرو', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text('ابزار قدرتمند خلق محتوای حرفه‌ای', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    final items = [
      {'name': 'اینستاگرام', 'icon': Icons.camera_alt, 'color': Colors.pink},
      {'name': 'تلگرام', 'icon': Icons.send, 'color': Colors.blue},
      {'name': 'یوتیوب', 'icon': Icons.play_arrow, 'color': Colors.red},
      {'name': 'تیک‌تاک', 'icon': Icons.music_note, 'color': Colors.white},
      {'name': 'روبینو', 'icon': Icons.grid_view, 'color': Colors.orange},
      {'name': 'ایتا', 'icon': Icons.chat, 'color': Colors.orangeAccent},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(items[index]['icon'] as IconData, color: items[index]['color'] as Color, size: 30),
            const SizedBox(height: 8),
            Text(items[index]['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.cardBg,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'سفارشات'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'سفارش جدید'),
        BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'پشتیبانی'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'پروفایل'),
      ],
    );
  }
}
