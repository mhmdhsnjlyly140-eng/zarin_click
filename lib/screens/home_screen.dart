import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db_service.dart'; // تغییر نام به DbService

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _coins = 0;
  String _userId = '';
  bool _isLoading = true;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('user_id');
    
    if (uid == null) {
      uid = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('user_id', uid);
    }
    
    setState(() {
      _userId = uid!;
      _isLoading = false;
    });

    // اتصال اولیه به دیتابیس Turso
    await DbService.initUser(_userId);

    // تایمر ذخیره خودکار هر ۵ ثانیه
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _saveCoinsToDb();
    });
  }

  Future<void> _saveCoinsToDb() async {
    if (_userId.isEmpty) return;
    if (_coins > 0) {
      final error = await DbService.updateCoins(_userId, _coins);
      if (error != null) {
        debugPrint('خطای ذخیره خودکار: $error');
      } else {
        debugPrint('✅ ذخیره خودکار انجام شد: $_coins سکه');
      }
    }
  }

  void _onClick() {
    setState(() {
      _coins++;
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _saveCoinsToDb(); // ذخیره نهایی قبل از خروج
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(child: CircularProgressIndicator(color: Colors.amber)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('زرین کلیک', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet, size: 60, color: Colors.amber),
            const SizedBox(height: 20),
            Text('موجودی سکه‌های شما', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
            const SizedBox(height: 10),
            Text('$_coins', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _onClick,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: const Center(
                  child: Text('کلیک کن!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('سکه‌ها به صورت خودکار ذخیره می‌شوند! ⏳', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final error = await DbService.updateCoins(_userId, _coins);
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('نتیجه تست اتصال'),
                      content: Text(error == null 
                        ? '✅ اتصال به Turso برقرار شد و داده‌ها ذخیره شدند!' 
                        : '❌ خطا:\n\n$error'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx), 
                          child: const Text('باشه')
                        )
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('تست اتصال به دیتابیس', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}