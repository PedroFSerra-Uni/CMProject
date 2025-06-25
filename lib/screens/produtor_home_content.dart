import 'package:flutter/material.dart';
import 'producer_ad_detail_screen.dart';


class ProdutorHomeContent extends StatelessWidget {
  const ProdutorHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟨 Paid Banner
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://via.placeholder.com/400x160.png?text=Anúncio+de+Máquinas+Agrícolas'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),

          const SectionTitle(title: 'Máquinas e Equipamentos'),
          HorizontalAdList(),

          const SectionTitle(title: 'Fertilizantes e Insumos'),
          HorizontalAdList(),

          const SectionTitle(title: 'Serviços Recomendados'),
          HorizontalAdList(),
        ],
      ),
    );
  }
}
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}


class HorizontalAdList extends StatelessWidget {
  final List<Map<String, String>> mockAds = [
    {
      'title': 'Trator John Deere',
      'subtitle': 'Desconto de 10%',
    },
    {
      'title': 'Fertilizante Orgânico',
      'subtitle': 'Envio grátis',
    },
    {
      'title': 'Sistema de Irrigação',
      'subtitle': 'Instalação incluída',
    },
    {
      'title': 'Serviço de Aragem',
      'subtitle': 'Agende já',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mockAds.length,
        itemBuilder: (_, index) {
          final ad = mockAds[index];
          return GestureDetector(
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (_) => ProducerAdDetailScreen(
              title: ad['title']!,
              subtitle: ad['subtitle']!,
              imageUrl: 'https://via.placeholder.com/400x200.png?text=${Uri.encodeComponent(ad['title']!)}',
            ),


            ),

            );
          },

            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.agriculture, size: 36, color: Colors.green),
                  const SizedBox(height: 8),
                  Text(ad['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(ad['subtitle']!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

