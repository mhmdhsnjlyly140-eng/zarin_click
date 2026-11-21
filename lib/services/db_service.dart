import 'package:libsql_dart/libsql_dart.dart';

class DbService {
  // آدرس دیتابیس Turso شما
  static const String _dbUrl = 'libsql://zarinklick-mhmdhsnjlyly140-eng.aws-us-west-2.turso.io';
  
  // توکن دسترسی Turso شما
  static const String _authToken = 'eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJhIjoicnciLCJpYXQiOjE3OTUyNzM0NzIsImlkIjoiMDFhMWZlYTAtMjcwMS03ODczLTljOTEtYWU2MGY0MmM5MDAxIiwia2lkIjoiQ2tSOXl3MDFZNlJMMEd4cmRuWnhsck11YmRwblJfS1VVSi1nY0RJaVI2SSIsInJpZCI6ImYzNWNiYTNmLTVjNTItNGJhYy1iM2ZiLWRkNzAxYTliMWI1ZCJ9.N_kgT2oI8EDcoT1Kl2iQp8jzfuYbj_oNY1XYcYYQN1xchlqox9CVGMvdMBuH2Tm0e1Y8l6wvZkfE1-CAvVEVAg';

  static LibsqlClient? _client;

  static Future<LibsqlClient> _getClient() async {
    if (_client != null) return _client!;
    final client = LibsqlClient.remote(_dbUrl, authToken: _authToken);
    await client.connect();
    _client = client;
    return client;
  }

  // ساخت جدول کاربران در صورت عدم وجود
  static Future<void> initTable() async {
    try {
      final client = await _getClient();
      await client.execute('''
        CREATE TABLE IF NOT EXISTS users (
          user_id TEXT PRIMARY KEY,
          coins INTEGER DEFAULT 0,
          last_click TEXT
        );
      ''');
    } catch (e) {
      print('Error initTable: $e');
    }
  }

  // ثبت‌نام کاربر جدید
  static Future<String?> initUser(String userId) async {
    try {
      final client = await _getClient();
      await initTable();
      
      final result = await client.query(
        'SELECT * FROM users WHERE user_id = ?',
        positional: [userId],
      );

      if (result.isEmpty) {
        await client.execute(
          'INSERT INTO users (user_id, coins, last_click) VALUES (?, 0, ?)',
          positional: [userId, DateTime.now().toIso8601String()],
        );
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // آپدیت سکه‌های کاربر
  static Future<String?> updateCoins(String userId, int coins) async {
    try {
      final client = await _getClient();
      final result = await client.query(
        'SELECT * FROM users WHERE user_id = ?',
        positional: [userId],
      );

      if (result.isEmpty) {
        await client.execute(
          'INSERT INTO users (user_id, coins, last_click) VALUES (?, ?, ?)',
          positional: [userId, coins, DateTime.now().toIso8601String()],
        );
      } else {
        await client.execute(
          'UPDATE users SET coins = ?, last_click = ? WHERE user_id = ?',
          positional: [coins, DateTime.now().toIso8601String(), userId],
        );
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}