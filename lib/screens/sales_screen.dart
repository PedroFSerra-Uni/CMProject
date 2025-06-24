import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'criar_anuncio_screen.dart';  


class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  int _currentTabIndex = 0;

  final List<String> tabs = ['Vendas', 'Anúncios'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: List.generate(tabs.length, (index) => index == _currentTabIndex),
          onPressed: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          children: tabs
              .map((tab) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(tab),
                  ))
              .toList(),
        ),
        Expanded(
          child: _currentTabIndex == 0 ? ScheduledDeliveries() : PublishedAds(),
        )
      ],
    );
  }
}

class ScheduledDeliveries extends StatelessWidget {
  const ScheduledDeliveries({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('deliveries').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Erro ao carregar dados.'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) return const Center(child: Text('Nenhuma entrega agendada.'));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final delivery = docs[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(delivery['type'] ?? '',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (delivery['location'] != null) Text('Local: ${delivery['location']}'),
                    if (delivery['phone'] != null) Text('Telefone: ${delivery['phone']}'),
                    if (delivery['pickupDate'] != null) Text('Recolha: ${delivery['pickupDate']}'),
                    if (delivery['deliveryDate'] != null) Text('Entrega: ${delivery['deliveryDate']}'),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Detalhes'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PublishedAds extends StatelessWidget {
  const PublishedAds({super.key});

  Uint8List decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return Uint8List(0);
    if (base64String.contains(',')) base64String = base64String.split(',')[1];
    try {
      return base64Decode(base64String.trim());
    } catch (_) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ads').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Erro ao carregar anúncios.'));
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) return const Center(child: Text('Nenhum anúncio publicado.'));

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final ad = docs[index].data() as Map<String, dynamic>;

                  // Proteção contra null
                  final title = ad['title'] as String? ?? '';
                  final date = ad['date'] as String? ?? '';
                  final quantity = ad['quantity'] as String? ?? '';
                  final imageBase64 = ad['imageBase64'] as String? ?? '';

                  final imageBytes = decodeBase64Image(imageBase64);

                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        imageBytes.isNotEmpty
                            ? Image.memory(imageBytes, width: 100, height: 100, fit: BoxFit.cover)
                            : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Data: $date'),
                              Text('Quantidade: $quantity'),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAdScreen()),
                  );
                },
                child: const Text('Criar Anúncio'),
              ),
            )
          ],
        );
      },
    );
  }
}
