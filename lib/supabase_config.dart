
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl =
      'https://uegdjhozzwxpiqbflxli.supabase.co';

  static const String supabasePublishableKey =
      'sb_publishable_Om8JZWIuK29qfILLNI3c9A_eBmFD5hn';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
  }

  static SupabaseClient get client =>
      Supabase.instance.client;
}
