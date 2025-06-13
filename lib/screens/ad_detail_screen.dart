import 'package:flutter/material.dart';

class AdDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdDetailScreen({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.agriculture, size: 100, color: Colors.green),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Text(subtitle, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 24),
            const Text(
              'Mais detalhes sobre este anúncio aqui...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
