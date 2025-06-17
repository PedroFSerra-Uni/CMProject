import 'package:flutter/material.dart';

class EditarBancaScreen extends StatefulWidget {
  final String nomeBanca;
  final String descricao;
  final String localizacao; // Endereço ou morada
  final String coordenadas; // Latitude e longitude em texto
  final List<String> mercados;
  final List<Map<String, dynamic>> criticas;

  const EditarBancaScreen({
    super.key,
    required this.nomeBanca,
    required this.descricao,
    required this.localizacao,
    required this.coordenadas,
    required this.mercados,
    required this.criticas,
  });

  @override
  State<EditarBancaScreen> createState() => _EditarBancaScreenState();
}

class _EditarBancaScreenState extends State<EditarBancaScreen> {
  late TextEditingController nomeController;
  late TextEditingController moradaController;
  late TextEditingController descricaoController;
  late TextEditingController novoMercadoController;

  late String localizacaoSelecionada;
  List<String> mercadosHabitais = [];

  // Exemplo de locais disponíveis (pode alterar conforme sua necessidade)
  final List<String> locaisDisponiveis = [
    'Rua das Flores, 123',
    'Avenida Central, 45',
    'Praça da Liberdade, 10'
  ];

  // Lista de URLs ou caminhos para as imagens (exemplo inicial)
  List<String> imagens = [
    'https://picsum.photos/id/237/300/150',
    'https://picsum.photos/id/238/300/150',
  ];

  @override
  void initState() {
    super.initState();

    nomeController = TextEditingController(text: widget.nomeBanca);

    // Agora o controller da morada recebe o endereço (localizacao)
    moradaController = TextEditingController(text: widget.localizacao);

    descricaoController = TextEditingController(text: widget.descricao);
    novoMercadoController = TextEditingController();

    localizacaoSelecionada = widget.localizacao;
    mercadosHabitais = List.from(widget.mercados);
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
    if (nome.trim().isNotEmpty) {
      setState(() {
        mercadosHabitais.add(nome.trim());
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

  void selecionarNovaImagem() {
    // TODO: implementar a lógica para selecionar uma nova imagem
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de adicionar imagem ainda não implementada.')),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
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
              decoration: _inputDecoration(),
            ),
            const SizedBox(height: 20),

            const Text('Detalhes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),

            const Text('Localização:'),
            DropdownButton<String>(
              value: localizacaoSelecionada,
              isExpanded: true,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    localizacaoSelecionada = newValue;
                    moradaController.text = newValue; // Sincroniza morada ao selecionar localização
                  });
                }
              },
              items: locaisDisponiveis
                  .map((value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
            ),

            const SizedBox(height: 10),
            const Text('Morada:'),
            TextField(
              controller: moradaController,
              decoration: _inputDecoration(),
              onChanged: (value) {
                if (localizacaoSelecionada != value) {
                  setState(() {
                    localizacaoSelecionada = value; // Tenta manter sincronizado
                  });
                }
              },
            ),

            const SizedBox(height: 10),
            const Text('Coordenadas:'),
            Text(widget.coordenadas, style: const TextStyle(fontSize: 14, color: Colors.grey)),

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
                    decoration: const InputDecoration(hintText: 'Novo mercado'),
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
                itemCount: imagens.length + 1,
                itemBuilder: (context, index) {
                  if (index < imagens.length) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.network(
                        imagens[index],
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
                hintStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: lógica de submissão dos dados editados
                    Navigator.pop(context);
                  },
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
