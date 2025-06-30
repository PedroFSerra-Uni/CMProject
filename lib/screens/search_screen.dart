import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _priceValue = 100.0;
  bool _hasSearched = false;

  final Map<String, bool> _categories = {
    'Vegetal': false,
    'Fruta': false,
    'Legumes': false,
    'Outros': false,
  };

  // Opções de entrega correspondentes às keys no deliveryOptions do anúncio
  final Map<String, bool> _deliveryOptions = {
    'consumidor_recolhe': false,
    'entrega_domicilio': false,
    'entrega_transportadora': false,
  };

  List<Map<dynamic, dynamic>> _ads = [];
  List<Map<dynamic, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _fetchAds();
  }

  Future<void> _fetchAds() async {
    final dbRef = FirebaseDatabase.instance.ref('ads');
    final snapshot = await dbRef.get();
    if (snapshot.exists) {
      final List<Map<dynamic, dynamic>> ads = [];
      snapshot.children.forEach((child) {
        final value = child.value;
        if (value is Map<dynamic, dynamic>) {
          ads.add(value);
        }
      });
      setState(() {
        _ads = ads;
        _filtered = _filterAds();
      });
    }
  }

  List<Map<dynamic, dynamic>> _filterAds() {
  final searchText = _searchController.text.toLowerCase();
  final selectedCategories = _categories.entries.where((e) => e.value).map((e) => e.key).toList();
  final selectedDelivery = _deliveryOptions.entries.where((e) => e.value).map((e) => e.key).toList();

  return _ads.where((ad) {
    final title = (ad['productName'] ?? '').toString().toLowerCase();
    final category = (ad['category'] ?? '').toString();
    final priceStr = (ad['price'] ?? '').toString().replaceAll(',', '.');
    final price = double.tryParse(priceStr) ?? double.infinity;
    final delivery = Map<String, dynamic>.from(ad['deliveryOptions'] ?? {});

    final matchText = searchText.isEmpty || title.contains(searchText);
    final matchCategory = selectedCategories.isEmpty || selectedCategories.contains(category);

    // Agora só aceita se **todas** as opções selecionadas forem true
    final matchDelivery = selectedDelivery.isEmpty ||
        selectedDelivery.every((opt) => delivery[opt] == true);

    final matchPrice = price <= _priceValue;

    return matchText && matchCategory && matchDelivery && matchPrice;
  }).toList();
}


  void _performSearch() {
    setState(() {
      _hasSearched = true;
      _filtered = _filterAds();
    });
  }

  void _applyFilters() {
    Navigator.pop(context);
    _performSearch();
  }

  Widget _buildAdCard(Map<dynamic, dynamic> ad) {
    final title = ad['productName'] ?? 'Sem título';
    final price = ad['price'] ?? '--';
    final imageBase64 = (ad['imagesBase64'] as List?)?.first;
    ImageProvider? image;

    if (imageBase64 != null && imageBase64 is String && imageBase64.isNotEmpty) {
      try {
        image = MemoryImage(base64Decode(imageBase64));
      } catch (_) {}
    }

    return Card(
      child: ListTile(
        leading: image != null ? Image(image: image, width: 60, height: 60, fit: BoxFit.cover) : null,
        title: Text(title),
        subtitle: Text('Preço: €$price'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductDetailScreen(ad: ad)),
          );
        },
      ),
    );
  }

  Widget _buildFiltersDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Categorias', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ..._categories.entries.map((entry) => CheckboxListTile(
                title: Text(entry.key),
                value: entry.value,
                onChanged: (val) => setState(() => _categories[entry.key] = val!),
              )),
          const SizedBox(height: 10),
          const Text('Entrega', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ..._deliveryOptions.entries.map((entry) => CheckboxListTile(
                // Mostrar nomes mais amigáveis para o utilizador
                title: Text(_deliveryOptionLabel(entry.key)),
                value: entry.value,
                onChanged: (val) => setState(() => _deliveryOptions[entry.key] = val!),
              )),
          const SizedBox(height: 10),
          const Text('Preço máximo'),
          Slider(
            value: _priceValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: '€${_priceValue.toStringAsFixed(2)}',
            onChanged: (val) => setState(() => _priceValue = val),
          ),
          ElevatedButton(
            onPressed: _applyFilters,
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // Função para mostrar um nome amigável para a opção de entrega
  String _deliveryOptionLabel(String key) {
    switch (key) {
      case 'consumidor_recolhe':
        return 'Recolha no local';
      case 'entrega_domicilio':
        return 'Entrega ao domicílio';
      case 'entrega_transportadora':
        return 'Entrega por transportadora';
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pesquisar Produtos'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: _buildFiltersDrawer(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _performSearch(),
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Expanded(
            child: !_hasSearched
                ? const Center(child: Text('Pesquise para ver resultados'))
                : _filtered.isEmpty
                    ? const Center(child: Text('Nenhum resultado encontrado'))
                    : ListView(
                        children: _filtered.map((ad) => _buildAdCard(ad)).toList(),
                      ),
          ),
        ],
      ),
    );
  }
}
