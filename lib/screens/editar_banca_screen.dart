import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarBancaScreen extends StatefulWidget {
  final String nomeBanca;
  final String descricao;
  final String localizacao; // Endereço ou morada
  final List<String> mercados;
  final List<Map<String, dynamic>> criticas;
  final List<String> imagensBase64;

  const EditarBancaScreen({
    super.key,
    required this.nomeBanca,
    required this.descricao,
    required this.localizacao,
    required this.mercados,
    required this.criticas,
    required this.imagensBase64,
  });

  @override
  State<EditarBancaScreen> createState() => _EditarBancaScreenState();
}

class _EditarBancaScreenState extends State<EditarBancaScreen> {
  late TextEditingController nomeController;
  late TextEditingController moradaController;
  late TextEditingController descricaoController;
  late TextEditingController novoMercadoController;

  List<String> mercadosHabitais = [];
  List<String> imagensBase64 = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nomeBanca);
    moradaController = TextEditingController(text: widget.localizacao);
    descricaoController = TextEditingController(text: widget.descricao);
    novoMercadoController = TextEditingController();
    mercadosHabitais = List.from(widget.mercados);
    imagensBase64 = List.from(widget.imagensBase64);
  }

  @override
  void dispose() {
    nomeController.dispose();
    moradaController.dispose();
    descricaoController.dispose();
    novoMercadoController.dispose();
    super.dispose();
  }

  void adicionarMercado(String nome) {
    final mercado = nome.trim();
    if (mercado.isNotEmpty && !mercadosHabitais.contains(mercado)) {
      setState(() {
        mercadosHabitais.add(mercado);
        novoMercadoController.clear();
      });
    }
  }

  void removerUltimoMercado() {
    if (mercadosHabitais.isNotEmpty) {
      setState(() {
        mercadosHabitais.removeLast();
      });
    }
  }

  Future<void> selecionarNovaImagem() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);
      setState(() {
        imagensBase64.add(base64String);
      });
    }
  }

  void removerImagem(int index) {
    setState(() {
      imagensBase64.removeAt(index);
    });
  }

  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _editarBanca() {
    final nome = nomeController.text.trim();
    final morada = moradaController.text.trim();
    final descricao = descricaoController.text.trim();

    if (nome.isEmpty || morada.isEmpty || descricao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    Navigator.pop(context, {
      'nomeBanca': nome,
      'descricao': descricao,
      'localizacao': morada,
      'mercados': mercadosHabitais,
      'criticas': widget.criticas,
      'imagensBase64': imagensBase64,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Banca'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nome da banca', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: nomeController,
              decoration: _inputDecoration(hintText: 'Digite o nome da banca'),
            ),
            const SizedBox(height: 20),

            const Text('Detalhes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),

            const Text('Localização:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: moradaController,
              decoration: _inputDecoration(hintText: 'Digite a localização'),
            ),

            const SizedBox(height: 20),
            const Text('Mercados Habituais', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mercadosHabitais
                  .map((mercado) => Chip(
                        label: Text(mercado),
                        backgroundColor: Colors.grey[600],
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: novoMercadoController,
                    decoration: _inputDecoration(hintText: 'Novo mercado'),
                  ),
                ),
                IconButton(
                  onPressed: () => adicionarMercado(novoMercadoController.text),
                  icon: const Icon(Icons.add_circle),
                ),
                IconButton(
                  onPressed: removerUltimoMercado,
                  icon: const Icon(Icons.remove_circle),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text('Imagens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text('Edite imagens da banca'),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagensBase64.length + 1,
                itemBuilder: (context, index) {
                  if (index < imagensBase64.length) {
                    Uint8List imageBytes = base64Decode(imagensBase64[index]);
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              imageBytes,
                              width: 300,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 300,
                                height: 150,
                                color: Colors.grey,
                                child: const Center(child: Text('Imagem não encontrada')),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 15,
                          child: GestureDetector(
                            onTap: () => removerImagem(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GestureDetector(
                      onTap: selecionarNovaImagem,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add_photo_alternate, size: 50),
                      ),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 6),
            TextField(
              controller: descricaoController,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.green[600],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'Digite a descrição',
                hintStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _editarBanca,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                  child: const Text('Editar Banca'),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
