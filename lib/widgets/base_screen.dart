import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<BottomNavigationBarItem> bottomNavItems;

  const BaseScreen({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.bottomNavItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.agriculture),
            SizedBox(width: 8),
            Text('HelloFarmer'),
          ],
        ),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 16),
          Icon(Icons.account_circle),
          SizedBox(width: 12),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/historico');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Definições'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/definicoes');
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/faq');
              },
            ),
            ListTile(
              leading: const Icon(Icons.headset_mic),
              title: const Text('Assistente Voz'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/assistente-voz');
              },
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabSelected,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: bottomNavItems,
      ),
    );
  }
}
