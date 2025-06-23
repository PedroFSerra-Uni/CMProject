import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({Key? key}) : super(key: key);

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final _productNameController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Vegetal', 'Fruta', 'Legume', 'Outros'];

  List<String> _imageBase64List = [];

  bool _deliveryHome = false;
  bool _consumerPickup = false;
  bool _courierDelivery = false;

  final _minQuantityController = TextEditingController();
  String? _selectedUnit;
  final List<String> _units = ['kg', 'unidade'];

  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _database = FirebaseDatabase.instance.ref();

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        List<String> base64Images = [];
        for (var file in pickedFiles) {
          final bytes = await File(file.path).readAsBytes();
          base64Images.add(base64Encode(bytes));
        }
        setState(() {
          _imageBase64List = base64Images;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao escolher imagens: $e')),
      );
    }
  }

  void _cancel() {
    setState(() {
      _productNameController.clear();
      _selectedCategory = null;
      _imageBase64List.clear();
      _deliveryHome = false;
      _consumerPickup = false;
      _courierDelivery = false;
      _minQuantityController.clear();
      _selectedUnit = null;
      _priceController.clear();
      _descriptionController.clear();
    });
  }

  void _preview() {
    // Pode ser implementado conforme necessidade. Exemplo simples:
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pré-visualização do Anúncio'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${_productNameController.text}'),
              Text('Categoria: ${_selectedCategory ?? ''}'),
              Text('Imagens: ${_imageBase64List.length} selecionadas'),
              Text('Entrega ao domicílio: ${_deliveryHome ? "Sim" : "Não"}'),
              Text('Consumidor recolhe: ${_consumerPickup ? "Sim" : "Não"}'),
              Text('Entrega transportadora: ${_courierDelivery ? "Sim" : "Não"}'),
              Text('Quantidade mínima: ${_minQuantityController.text} ${_selectedUnit ?? ""}'),
              Text('Preço: ${_priceController.text}'),
              Text('Descrição: ${_descriptionController.text}'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Fechar')),
        ],
      ),
    );
  }

  Future<void> _publishAd() async {
    final productName = _productNameController.text.trim();
    final category = _selectedCategory;
    final images = _imageBase64List;
    final deliveryOptions = {
      'entrega_domicilio': _deliveryHome,
      'consumidor_recolhe': _consumerPickup,
      'entrega_transportadora': _courierDelivery,
    };
    final minQuantity = _minQuantityController.text.trim();
    final unit = _selectedUnit;
    final price = _priceController.text.trim();
    final description = _descriptionController.text.trim();

    // Validações básicas
    if (productName.isEmpty ||
        category == null ||
        images.isEmpty ||
        (!deliveryOptions.containsValue(true)) ||
        minQuantity.isEmpty ||
        unit == null ||
        price.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios e selecione pelo menos uma opção de entrega.')),
      );
      return;
    }

    final adRef = _database.child('ads').push();

    final adData = {
      'productName': productName,
      'category': category,
      'imagesBase64': images,
      'deliveryOptions': deliveryOptions,
      'minQuantity': minQuantity,
      'unit': unit,
      'price': price,
      'description': description,
      'date': DateTime.now().toIso8601String(),
    };

    try {
      await adRef.set(adData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anúncio publicado com sucesso!')),
      );
      _cancel();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao publicar anúncio: $e')),
      );
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _minQuantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Anúncio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _productNameController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Categoria'),
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.photo_library),
              label: Text('Selecionar Imagens (${_imageBase64List.length})'),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _imageBase64List.map((base64Str) {
                final bytes = base64Decode(base64Str);
                return Image.memory(bytes, width: 80, height: 80, fit: BoxFit.cover);
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Opções de Entrega', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            CheckboxListTile(
              title: const Text('Entrega ao domicílio'),
              value: _deliveryHome,
              onChanged: (val) => setState(() => _deliveryHome = val ?? false),
            ),
            CheckboxListTile(
              title: const Text('Consumidor recolhe ao produto'),
              value: _consumerPickup,
              onChanged: (val) => setState(() => _consumerPickup = val ?? false),
            ),
            CheckboxListTile(
              title: const Text('Entrega por transportadora'),
              value: _courierDelivery,
              onChanged: (val) => setState(() => _courierDelivery = val ?? false),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Detalhes de Venda', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minQuantityController,
                    decoration: const InputDecoration(labelText: 'Quantidade mínima'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Unidade'),
                    value: _selectedUnit,
                    items: _units
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedUnit = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 4,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _cancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _preview,
                  child: const Text('Pré-visualizar'),
                ),
                ElevatedButton(
                  onPressed: _publishAd,
                  child: const Text('Publicar Anúncio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
