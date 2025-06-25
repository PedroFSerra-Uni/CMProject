import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CriarBancaScreen extends StatefulWidget {
  const CriarBancaScreen({super.key});

  @override
  State<CriarBancaScreen> createState() => _CriarBancaScreenState();
}

class _CriarBancaScreenState extends State<CriarBancaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _moradaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _mercadoController = TextEditingController();
  final TextEditingController _localizacaoController = TextEditingController();

  final List<String> _mercados = [];
  final List<String> _imageBase64List = [];

  final ImagePicker _picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _carregarBancaDoUsuario();
  }

  Future<void> _carregarBancaDoUsuario() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('bancas').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nomeController.text = data['nome'] ?? '';
          _moradaController.text = data['morada'] ?? '';
          _descricaoController.text = data['descricao'] ?? '';
          _localizacaoController.text = data['localizacao'] ?? '';
          _mercados.clear();
          _mercados.addAll(List<String>.from(data['mercados'] ?? []));
          _imageBase64List.clear();
          _imageBase64List.addAll(List<String>.from(data['imagensBase64'] ?? []));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar banca: $e')),
      );
    }
  }

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
          _imageBase64List.addAll(base64Images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao escolher imagens: $e')),
      );
    }
  }

  void _adicionarMercado() {
    final mercado = _mercadoController.text.trim();
    if (mercado.isNotEmpty && !_mercados.contains(mercado)) {
      setState(() {
        _mercados.add(mercado);
        _mercadoController.clear();
      });
    }
  }

  Future<void> _criarBanca() async {
    final nome = _nomeController.text.trim();
    final morada = _moradaController.text.trim();
    final descricao = _descricaoController.text.trim();
    final localizacao = _localizacaoController.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome da banca')),
      );
      return;
    }
    if (localizacao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a localização')),
      );
      return;
    }
    if (morada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira a morada')),
      );
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Utilizador não autenticado')),
        );
        return;
      }

      // Grava no Firestore
      await _firestore.collection('bancas').doc(user.uid).set({
        'nome': nome,
        'morada': morada,
        'descricao': descricao,
        'localizacao': localizacao,
        'mercados': _mercados,
        'imagensBase64': _imageBase64List,
        'criticas': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banca criada com sucesso!')),
      );

      // Navega para ecrã principal da banca (ajusta conforme o teu router)
      Navigator.pushNamed(context, '/banca-home');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar banca: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Banca'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Nome da Banca"),
            _buildTextField("Nome da banca", _nomeController),

            const SizedBox(height: 24),

            _buildSectionTitle("Detalhes"),
            const SizedBox(height: 8),
            _buildTextField("Localização", _localizacaoController),
            const SizedBox(height: 12),
            _buildTextField("Morada", _moradaController),

            const SizedBox(height: 24),

            _buildSectionTitle("Mercados habituais"),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildTextField("Adicionar mercado", _mercadoController)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 30),
                  onPressed: _adicionarMercado,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _mercados
                  .map((m) => Chip(
                        label: Text(m),
                        onDeleted: () {
                          setState(() {
                            _mercados.remove(m);
                          });
                        },
                      ))
                  .toList(),
            ),

            const SizedBox(height: 32),

            _buildSectionTitle("Imagens da banca"),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._imageBase64List.map((base64) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: MemoryImage(base64Decode(base64)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.green),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Descrição da banca"),
            const SizedBox(height: 8),
            _buildDescriptionField(),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _criarBanca,
                  child: const Text("Criar Banca"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descricaoController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Descrição da banca...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}