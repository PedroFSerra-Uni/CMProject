import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import 'produtor_home_content.dart';
import 'sales_screen.dart';

class ProdutorHome extends StatefulWidget {
  const ProdutorHome({super.key});

  @override
  State<ProdutorHome> createState() => _ProdutorHomeState();
}

class _ProdutorHomeState extends State<ProdutorHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProdutorHomeContent(),
    const Center(child: Text('Pesquisa')),
    const Center(child: Text('Mensagens')),
    const SalesScreen(),
    const Center(child: Text('Minha Loja')),
  ];

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
