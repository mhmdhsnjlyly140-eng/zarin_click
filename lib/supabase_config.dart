
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';

  static const String supabasePublishableKey =
      'YOUR_SUPABASE_PUBLISHABLE_KEY';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: https://uegdjhozzwxpiqbflxli.supabase.co/rest/v1/,
      publishableKey: sb_publishable_Om8JZWIuK29qfILLNI3c9A_eBmFD5hn,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
