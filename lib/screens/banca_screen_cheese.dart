import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/editar_banca_screen.dart';

import '../widgets/base_screen.dart';
import 'criar_banca_screen.dart';
import 'message_home_screen.dart';
import 'sales_screen.dart';

class BancaHomeScreenCheese extends StatefulWidget {
  const BancaHomeScreenCheese({super.key});

  @override
  State<BancaHomeScreenCheese> createState() => _BancaHomeScreenCheeseState();
}

class _BancaHomeScreenCheeseState extends State<BancaHomeScreenCheese> {
  Map<String, dynamic>? bancaData;
  int _selectedIndex = 4; // banca tab is index 4

  @override
  void initState() {
    super.initState();
    _loadBanca();
  }

  Future<void> _loadBanca() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('bancas').doc(user.uid).get();
    if (doc.exists) {
      setState(() {
        bancaData = doc.data();
      });
    }
  }

  void _onTabSelected(int index) {
    if (index == _selectedIndex) return; // do nothing if same tab

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/produtor-home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/search-screen');
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MessageHomeScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SalesScreen()),
      );
    } else if (index == 4) {
      // Already here, do nothing
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bancaData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  bancaData!['nome'] ?? 'Minha Banca',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditarBancaScreen(
                        nomeBanca: bancaData!['nome'] ?? '',
                        descricao: bancaData!['descricao'] ?? '',
                        localizacao: bancaData!['localizacao'] ?? '',
                        mercados: List<String>.from(bancaData!['mercados'] ?? []),
                        criticas: List<Map<String, dynamic>>.from(bancaData!['criticas'] ?? []),
                        imagensBase64: List<String>.from(bancaData!['imagensBase64'] ?? []),
                      ),
                    ),
                  );

                  if (result != null && mounted) {
                    await FirebaseFirestore.instance
                        .collection('bancas')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      'nome': result['nomeBanca'],
                      'descricao': result['descricao'],
                      'localizacao': result['localizacao'],
                      'coordenadas': result['coordenadas'],
                      'mercados': result['mercados'],
                      'criticas': result['criticas'],
                      'imagensBase64': result['imagensBase64'],
                    });

                    await _loadBanca();
                  }
                },
                child: const Text('Editar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if ((bancaData!['imagensBase64'] as List).isNotEmpty)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: MemoryImage(
                      base64Decode((bancaData!['imagensBase64'] as List).first),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Text('Descrição', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            bancaData!['descricao'] ?? 'Sem descrição',
            softWrap: true,
          ),
          const SizedBox(height: 24),
          const Text('Detalhes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('📍 Localização: ${bancaData!['localizacao'] ?? 'N/A'}', softWrap: true),
          Text('🏠 Morada: ${bancaData!['morada'] ?? 'N/A'}', softWrap: true),
          const SizedBox(height: 24),
          const Text('Mercados habituais', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List<Widget>.from(
              (bancaData!['mercados'] as List).map(
                (m) => Chip(label: Text(m)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Críticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            (bancaData!['criticas'] as List).isEmpty
                ? 'Ainda sem críticas.'
                : 'Total de críticas: ${bancaData!['criticas'].length}',
          ),
        ],
      ),
    );

    return BaseScreen(
      body: content,
      selectedIndex: _selectedIndex,
      onTabSelected: _onTabSelected,
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
