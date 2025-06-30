import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<dynamic, dynamic> ad;

  const ProductDetailScreen({super.key, required this.ad});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String location = 'A carregar localização...';
  String bancaNome = 'A carregar nome da banca...';

  // Críticas pré-definidas
  final List<Map<String, String>> reviews = [
    {
      'user': 'João Silva',
      'comment': 'Produto de ótima qualidade, recomendo!',
    },
    {
      'user': 'Maria Fernandes',
      'comment': 'Entrega rápida e produto fresco.',
    },
    {
      'user': 'Carlos Pereira',
      'comment': 'Preço justo e atendimento excelente.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchBancaLocation();
  }

  Future<void> _fetchBancaLocation() async {
    try {
      final userId = widget.ad['userId'];
      if (userId == null) {
        setState(() {
          location = 'Localização indisponível';
          bancaNome = 'Nome da banca indisponível';
        });
        return;
      }

      final bancaSnapshot = await FirebaseFirestore.instance
          .collection('bancas')
          .doc(userId)
          .get();

      if (bancaSnapshot.exists) {
        final data = bancaSnapshot.data();
        setState(() {
          location = data?['localizacao'] ?? 'Localização não encontrada';
          bancaNome = data?['nome'] ?? 'Nome da banca não encontrado';
        });
      } else {
        setState(() {
          location = 'Banca não encontrada';
          bancaNome = 'Nome da banca não encontrado';
        });
      }
    } catch (e) {
      setState(() {
        location = 'Erro ao carregar localização';
        bancaNome = 'Erro ao carregar nome da banca';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.ad['productName'] ?? 'Sem título';
    final String price = widget.ad['price']?.toString() ?? '--';
    final List<dynamic>? imagesBase64 = widget.ad['imagesBase64'] as List<dynamic>?;
    ImageProvider? image;

    if (imagesBase64 != null && imagesBase64.isNotEmpty) {
      final String imageBase64 = imagesBase64.first;
      if (imageBase64.isNotEmpty) {
        try {
          image = MemoryImage(base64Decode(imageBase64));
        } catch (_) {}
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null)
              Image(image: image, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Preço: €$price', style: const TextStyle(fontSize: 18)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(bancaNome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(location, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Críticas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shrinkWrap: true,  // importante para ListView dentro de SingleChildScrollView
              physics: const NeverScrollableScrollPhysics(), // evitar scroll dentro do scroll
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(review['user']!),
                    subtitle: Text(review['comment']!),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
