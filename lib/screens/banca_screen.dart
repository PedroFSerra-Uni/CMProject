import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/base_screen.dart';
import 'criar_banca_screen.dart';

class BancaHomeScreen extends StatefulWidget {
  const BancaHomeScreen({super.key});

  @override
  State<BancaHomeScreen> createState() => _BancaHomeScreenState();
}

class _BancaHomeScreenState extends State<BancaHomeScreen> {
  Map<String, dynamic>? bancaData;

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

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      selectedIndex: 4,
      onTabSelected: (index) {
        // Navigate using your router or Navigator.push
      },
      bottomNavItems: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Pesquisa'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Mensagens'),
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Vendas'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Banca'),
      ],
      body: bancaData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bancaData!['nome'] ?? 'Minha Banca',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CriarBancaScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Editar Banca'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // First image centered
                  if ((bancaData!['imagensBase64'] as List).isNotEmpty)
                    Center(
                      child: Container(
                        width: double.infinity,
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

                  // Descrição
                  const Text('Descrição', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(bancaData!['descricao'] ?? 'Sem descrição'),

                  const SizedBox(height: 24),

                  // Detalhes
                  const Text('Detalhes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('📍 Localização: ${bancaData!['localizacao'] ?? 'N/A'}'),
                  Text('🏠 Morada: ${bancaData!['morada'] ?? 'N/A'}'),

                  const SizedBox(height: 24),

                  // Mercados
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

                  // Críticas (placeholder)
                  const Text('Críticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    (bancaData!['criticas'] as List).isEmpty
                        ? 'Ainda sem críticas.'
                        : 'Total de críticas: ${bancaData!['criticas'].length}',
                  ),
                ],
              ),
            ),
    );
  }
}
