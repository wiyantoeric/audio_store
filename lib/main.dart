import 'package:audio_store/provider/cart_provider.dart';
import 'package:audio_store/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.get('SUPABASE_URL');
  final supabaseKey = dotenv.get('SUPABASE_KEY');

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const AudioStoreApp(),
    ),
  );
}

class AudioStoreApp extends StatelessWidget {
  const AudioStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Audio Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
