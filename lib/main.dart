
import 'package:flutter/material.dart';
import 'supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.initialize();

  runApp(const ZarinClickApp());
}

class ZarinClickApp extends StatelessWidget {
  const ZarinClickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'زرین کلیک',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('زرین کلیک آماده اتصال است'),
        ),
      ),
    );
  }
}
