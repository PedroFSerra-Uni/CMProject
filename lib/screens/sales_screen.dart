import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ad_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  int _currentTabIndex = 0;

  final List<String> tabs = ['Vendas', 'Anúncios'];

  // Chamada para atualizar anúncios e ir para o separador "Anúncios"
  void _goToAdsTabAndRefresh() {
    setState(() {
      _currentTabIndex = 1; // "Anúncios"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleButtons(
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
        ),
        Expanded(
          child: _currentTabIndex == 0
              ? const ScheduledDeliveries()
              : PublishedAds(
                  onAdCreated: _goToAdsTabAndRefresh,
                ),
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

class PublishedAds extends StatefulWidget {
  final VoidCallback? onAdCreated;

  const PublishedAds({super.key, this.onAdCreated});


  @override
  State<PublishedAds> createState() => _PublishedAdsState();
}

class _PublishedAdsState extends State<PublishedAds> {
  final _database = FirebaseDatabase.instance.ref();
  List<Map<dynamic, dynamic>> _ads = [];
  bool _isLoading = true;

  Future<void> _navigateToCreateAd() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const CreateAdScreen()),
  );

  if (result == true) {
    await _loadAds(); // Atualiza lista de anúncios
    widget.onAdCreated?.call(); // Muda o separador para "Anúncios"
  }
}

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    try {
      final snapshot = await _database.child('ads').once();
      final data = snapshot.snapshot.value;

      if (data != null && data is Map<dynamic, dynamic>) {
        final adsList = data.entries.map<Map<dynamic, dynamic>>((entry) {
          final value = Map<dynamic, dynamic>.from(entry.value as Map);
          value['id'] = entry.key;
          return value;
        }).toList();

        setState(() {
          _ads = adsList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _ads = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar anúncios: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: _ads.isEmpty
              ? const Center(child: Text('Nenhum anúncio publicado.'))
              : ListView.builder(
                  itemCount: _ads.length,
                  itemBuilder: (context, index) {
                    final ad = _ads[index];
                    final String productName = ad['productName'] ?? '';
                    final String category = ad['category'] ?? '';
                    final String description = ad['description'] ?? '';
                    final String price = ad['price']?.toString() ?? '';
                    String? imageBase64;

                    if (ad['imagesBase64'] != null &&
                        ad['imagesBase64'] is List &&
                        (ad['imagesBase64'] as List).isNotEmpty) {
                      imageBase64 = (ad['imagesBase64'] as List).first as String;
                    }

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: imageBase64 != null
                            ? Image.memory(
                                base64Decode(imageBase64),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 60),
                        title: Text(productName),
                        subtitle: Text(
                          '$category\nPreço: $price€\n$description',
                          softWrap: true,
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToCreateAd,
              child: const Text('Criar Anúncio'),
            ),
          ),
        ),
      ],
    );
  }
}
