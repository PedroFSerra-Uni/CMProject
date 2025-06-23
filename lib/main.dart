import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_screen.dart';
import 'screens/produtor_home.dart';
import 'screens/product_detail_screen.dart';
import 'screens/ad_detail_screen.dart';
import 'screens/historico_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/assistente_voz_screen.dart';
import 'screens/profile_view_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDbkeY42GO66yubqt-3R5tqQzwmI1AaZNM',
      appId: '1:750817095550:android:ebfa90a80acd28c96e0d2f',
      messagingSenderId: '750817095550',
      projectId: 'hf-bd23',
      storageBucket: 'hf-bd23.firebasestorage.app',
      databaseURL: 'https://hf-bd23-default-rtdb.europe-west1.firebasedatabase.app/',
    ),
  );
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') rethrow;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Farmer',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/search-screen': (context) => const SearchScreen(),
        '/produtor-home': (context) => const ProdutorHome(),
        '/utilizador-home': (context) => const DummyScreen('Utilizador Home'),
        '/admin-dashboard': (context) => const DummyScreen('Admin Dashboard'),
        '/product-detail': (context) => const ProductDetailScreen(),
        '/ad-detail': (context) =>
            const AdDetailScreen(title: '', subtitle: ''),
        '/historico': (context) => const HistoricoScreen(),
        '/faq': (context) => const FAQScreen(),
        '/voice-assist': (context) => const VoiceAssistScreen(),
        '/profile-view-screen': (context) => const ProfileViewScreen(),
        '/profile-edit-screen': (context) => const ProfileEditScreen(),
        '/settings-screen': (context) => const SettingsScreen(),
      },
    );
  }
}

class DummyScreen extends StatelessWidget {
  final String title;
  const DummyScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Page')),
    );
  }
}
