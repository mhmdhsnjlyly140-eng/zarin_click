import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sheet_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _coins = 0;
  String _userId = '';
  bool _isLoading = true;

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

    // اتصال خودکار به گوگل شیت در پس‌زمینه
    await SheetService.initUser(_userId);
  }

  void _onClick() {
    setState(() {
      _coins++;
    });
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
            const SizedBox(height: 60),
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
            const SizedBox(height: 40),
            const Text('با هر کلیک، سکه طلایی بگیر!', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await SheetService.updateCoins(_userId, _coins);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سکه‌ها در گوگل شیت ذخیره شد! ✅')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('ذخیره در شیت', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}