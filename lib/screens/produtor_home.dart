import 'package:flutter/material.dart';
import 'package:project/screens/search_screen.dart';
import '../widgets/base_screen.dart';
import 'produtor_home_content.dart';
import 'sales_screen.dart';
import 'message_home_screen.dart';
import 'criar_banca_screen.dart';
import 'banca_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProdutorHome extends StatefulWidget {
  const ProdutorHome({super.key});

  @override
  State<ProdutorHome> createState() => _ProdutorHomeState();
}

class _ProdutorHomeState extends State<ProdutorHome> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
  const ProdutorHomeContent(),
  const SearchScreen(),
  MessageHomeScreen(),
  const SalesScreen(),
  const SizedBox(), // placeholder for banca screen
];

@override
void initState() {
  super.initState();
  _setupBancaScreen();
}

Future<void> _setupBancaScreen() async {
  bool hasBanca = await checkIfUserHasBanca();
  setState(() {
    _pages[4] = hasBanca ? const BancaHomeScreen() : const CriarBancaScreen();
  });
}

Future<bool> checkIfUserHasBanca() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return false;

  final doc = await FirebaseFirestore.instance
      .collection('bancas')
      .doc(userId)
      .get();

  return doc.exists;
}



  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: _pages[_selectedIndex],
      selectedIndex: _selectedIndex,
      onTabSelected: _onTabTapped,
      bottomNavItems: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Pesquisa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Mensagens',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sell),
          label: 'Vendas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Banca',
        ),
      ],
    );
  }
}
