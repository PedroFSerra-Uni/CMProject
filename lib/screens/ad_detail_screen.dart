import 'package:flutter/material.dart';
import 'dart:convert';

class AdDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String unit; // ✅ <-- make sure this is defined
  final String bancaName;
  final List<String> imagesBase64;
  final String category;
  final Map<String, bool> deliveryOptions;

  const AdDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.unit,          // ✅ <-- include it here too
    required this.bancaName,
    required this.imagesBase64,
    required this.category,
    required this.deliveryOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagesBase64.isNotEmpty)
              Image.memory(base64Decode(imagesBase64[0]), height: 200),
            const SizedBox(height: 12),
            Text(subtitle, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Categoria: $category'),
            Text('Preço: R\$ $price / $unit'), // ✅ using `unit` here
            Text('Banca: $bancaName'),
            Text(
              'Entrega: ${deliveryOptions.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
            ),
          ],
        ),
      ),
    );
  }
}
