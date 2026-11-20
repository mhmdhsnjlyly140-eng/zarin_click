
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
      home: const ConnectionTestPage(),
    );
  }
}

class ConnectionTestPage extends StatefulWidget {
  const ConnectionTestPage({super.key});

  @override
  State<ConnectionTestPage> createState() =>
      _ConnectionTestPageState();
}

class _ConnectionTestPageState
    extends State<ConnectionTestPage> {
  bool loading = false;
  String result = 'هنوز اتصال آزمایش نشده است';
  bool? connected;

  Future<void> testConnection() async {
    setState(() {
      loading = true;
      result = 'در حال بررسی اتصال...';
      connected = null;
    });

    try {
      final response = await SupabaseConfig.client
          .from('connection_test')
          .select()
          .limit(1);

      setState(() {
        connected = true;
        result = 'اتصال موفق است!\n'
            'دریافت اطلاعات از Supabase انجام شد.';
      });
    } catch (e) {
      setState(() {
        connected = false;
        result = 'خطا در اتصال یا دسترسی جدول:\n$e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('زرین کلیک'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.ads_click,
                size: 75,
                color: Colors.amber,
              ),
              const SizedBox(height: 20),
              const Text(
                'آزمایش اتصال دیتابیس',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Icon(
                connected == true
                    ? Icons.check_circle
                    : connected == false
                        ? Icons.error
                        : Icons.cloud,
                size: 55,
                color: connected == true
                    ? Colors.green
                    : connected == false
                        ? Colors.red
                        : Colors.blueGrey,
              ),
              const SizedBox(height: 15),
              Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : testConnection,
                  child: Text(
                    loading
                        ? 'در حال آزمایش...'
                        : 'آزمایش اتصال',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
