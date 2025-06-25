import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ad_detail_screen.dart';

class ConsumidorHomeScreen extends StatelessWidget {
  const ConsumidorHomeScreen({super.key});

  Future<String> fetchBancaName(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return doc.data()?['bancaName'] ?? 'Banca desconhecida';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos Disponíveis')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ads').orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Erro ao carregar anúncios.'));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          final ads = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index].data() as Map<String, dynamic>;

              return FutureBuilder<String>(
                future: fetchBancaName(ad['userId']),
                builder: (context, bancaSnapshot) {
                  final bancaName = bancaSnapshot.data ?? 'Carregando...';

                  final imageWidget = (ad['imagesBase64'] != null && ad['imagesBase64'].isNotEmpty)
                      ? Image.memory(
                          base64Decode(ad['imagesBase64'][0]),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 60),
                        );

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdDetailScreen(
                            title: ad['productName'] ?? '',
                            subtitle: ad['description'] ?? '',
                            price: ad['price'] ?? '',
                            unit: ad['unit'] ?? '',
                            bancaName: bancaName,
                            imagesBase64: List<String>.from(ad['imagesBase64'] ?? []),
                            category: ad['category'] ?? '',
                            deliveryOptions: Map<String, bool>.from(ad['deliveryOptions'] ?? {}),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: imageWidget,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ad['productName'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(ad['description'] ?? '', style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 6),
                                Text(
                                  'Preço: R\$ ${ad['price']} / ${ad['unit']}',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text('Vendida por: $bancaName', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
