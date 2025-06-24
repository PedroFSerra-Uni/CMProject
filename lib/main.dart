import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
<<<<<<< Updated upstream

void main() {
=======
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/produtor_home.dart';
import 'screens/product_detail_screen.dart';
import 'screens/ad_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/historico_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/assistente_voz_screen.dart';
import 'screens/profile_view_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'screens/criar_anuncio_screen.dart'; // Importa o ficheiro com a tela



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Importante para inicializar o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
>>>>>>> Stashed changes
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
        '/produtor-home': (context) => const DummyScreen('Produtor Home'),
        '/utilizador-home': (context) => const DummyScreen('Utilizador Home'),
        '/admin-dashboard': (context) => const DummyScreen('Admin Dashboard'),
      },
    );
  }
}

// Temporary placeholder
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
