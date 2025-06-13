import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';

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
  final List<Map<String, String>> deliveries = [
    {
      'type': 'Entrega ao domicílio',
      'location': 'Quinta do Conde, Setúbal',
      'phone': '+351 932340239',
      'deliveryDate': '04/05/2025 às 15:00',
    },
    {
      'type': 'Recolha transportadora',
      'pickupDate': '04/05/2025 às 15:00',
      'deliveryDate': '06/05/2025 às 16:30',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: deliveries.length,
      itemBuilder: (context, index) {
        final delivery = deliveries[index];
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
                if (delivery.containsKey('location')) Text('Local: ${delivery['location']}'),
                if (delivery.containsKey('phone')) Text('Telefone: ${delivery['phone']}'),
                if (delivery.containsKey('pickupDate')) Text('Recolha: ${delivery['pickupDate']}'),
                if (delivery.containsKey('deliveryDate')) Text('Entrega: ${delivery['deliveryDate']}'),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show details logic
                    },
                    child: const Text('Detalhes'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class PublishedAds extends StatefulWidget {
  @override
  State<PublishedAds> createState() => _PublishedAdsState();
}

class _PublishedAdsState extends State<PublishedAds> {
  List<Map<String, dynamic>> ads = [
    {
      'imageBase64': 'iVBORw0KGgoAAAANSUhEUgAAA...', // shortened for example
      'title': 'Batatas-Doces',
      'date': '19/04/2025',
      'quantity': '25/500kg',
    },
    {
      'imageBase64': 'iVBORw0KGgoAAAANSUhEUgAAA...',
      'title': 'Morangos',
      'date': '20/04/2025',
      'quantity': '7/200kg',
    },
  ];

  Uint8List decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return Uint8List(0);
    if (base64String.contains(',')) base64String = base64String.split(',')[1];
    try {
      return base64Decode(base64String.trim());
    } catch (_) {
      return Uint8List(0);
    }
  }

  void _editAd(BuildContext context, int index) {
    final ad = ads[index];
    final quantityString = ad['quantity'] ?? '';
    final match = RegExp(r'^(\d+)\s*/\s*(\d+)\s*(\w+)$').firstMatch(quantityString);

    String current = '0';
    String max = '0';
    String unit = '';

    if (match != null) {
      current = match.group(1)!;
      max = match.group(2)!;
      unit = match.group(3)!;
    }

    final controller = TextEditingController(text: current);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Quantidade'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nova quantidade'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final newAmount = controller.text.trim();
                if (newAmount.isNotEmpty) {
                  setState(() {
                    // Update both current and max, and preserve the unit
                    ad['quantity'] = '$newAmount/$newAmount$unit';
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }



  void _deleteAd(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar Anúncio'),
        content: const Text('Tem certeza de que deseja desativar este anúncio?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              setState(() {
                ads.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Desativar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              final imageBytes = decodeBase64Image(ad['imageBase64']);
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
                          Text(ad['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Data: ${ad['date']}'),
                          Text('Quantidade: ${ad['quantity']}'),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _editAd(context,index),
                                child: const Chip(label: Text('Editar')),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _deleteAd(index),
                                child: const Chip(label: Text('Desativar')),
                              ),
                            ],
                          )
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
              // Criar anúncio
            },
            child: const Text('Criar Anúncio'),
          ),
        )
      ],
    );
  }
}

