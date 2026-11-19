import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ZarinClickApp());
}

class ZarinClickApp extends StatelessWidget {
  const ZarinClickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'زرین کلیک',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37), // رنگ طلایی
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Vazir', // اگر فونت فارسی خواستی بعدا اضافه می‌کنیم
      ),
      home: const HomeScreen(),
    );
  }
}