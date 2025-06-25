import 'package:flutter/material.dart';

class ProducerAdDetailScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;

  const ProducerAdDetailScreen({
  super.key,
  required this.title,
  required this.subtitle,
  this.imageUrl,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              )
            else
              const Icon(Icons.agriculture, size: 100, color: Colors.green),

            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
