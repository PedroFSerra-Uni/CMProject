import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/utils/brightness_detector.dart';
import 'package:project/screens/banca_screen.dart';
import 'package:project/screens/consumidor_home_screen.dart';
import 'screens/producer_ad_detail_screen.dart';
import 'screens/stats_screen.dart';
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
import 'screens/criar_banca_screen.dart';
import 'screens/notification_service.dart';
import 'screens/sales_screen.dart';
import 'screens/map_screen.dart';
import 'screens/ad_screen.dart';

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

  await initializeNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BrightnessDetector(
      builder: (isDark) {
        return MaterialApp(
          title: 'Hello Farmer',
          theme: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(primary: Colors.green),
                )
              : ThemeData.light().copyWith(
                  primaryColor: Colors.green,
                  colorScheme: const ColorScheme.light(primary: Colors.green),
                ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/search-screen': (context) => const SearchScreen(),
            '/produtor-home': (context) => const ProdutorHome(),
            '/utilizador-home': (context) => const ConsumidorHomeScreen(),
            '/admin-dashboard': (context) => const DummyScreen('Admin Dashboard'),
            '/product-detail': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
              return ProductDetailScreen(ad: args);
            },

            '/ad-detail': (context) =>
                ProducerAdDetailScreen(title: '', subtitle: '', imageUrl: ''),
            '/historico': (context) => const HistoricoScreen(),
            '/faq': (context) => const FAQScreen(),
            '/voice-assist': (context) => const VoiceAssistScreen(),
            '/profile-view-screen': (context) => const ProfileScreen(),
            '/profile-edit-screen': (context) => const ProfileEditScreen(),
            '/settings-screen': (context) => const SettingsScreen(),
            '/criar-banca': (context) => const CriarBancaScreen(),
            '/banca-home': (context) => const BancaHomeScreen(),
            '/sales-screen': (context) => const SalesScreen(),
            '/map-screen': (context) => const MapScreen(),
            '/ad-screen': (context) => const CreateAdScreen(),
          },
        );
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