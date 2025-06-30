import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final List<Map<String, dynamic>> _produtos = [
    {
      'nome': 'Batata-Doce',
      'produtor': 'Produtor A',
      'preco': '5,99',
      'quantidade': '30',
      'imagemPath': 'assets/imagens/batata-doce.jpg',
    },
    {
      'nome': 'Pimentos',
      'produtor': 'Produtor B',
      'preco': '10,99',
      'quantidade': '20',
      'imagemPath': 'assets/imagens/pimentos.jpg',
    },
  ];

  void _adicionarStock(int index) {
    final TextEditingController _quantidadeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Stock'),
          content: TextField(
            controller: _quantidadeController,
            decoration: const InputDecoration(hintText: 'Quantidade a adicionar'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final quantidade = int.tryParse(_quantidadeController.text);
                if (quantidade != null && quantidade > 0) {
                  setState(() {
                    int quantidadeAtual = int.tryParse(_produtos[index]['quantidade']) ?? 0;
                    _produtos[index]['quantidade'] = (quantidadeAtual + quantidade).toString();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Adicionado $quantidade unidades a ${_produtos[index]['nome']}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Restock',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text('Histórico'),
    actions: [
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {}, // ação de deletar
      ),
    ],
  ),
  body: Container(
    color: Colors.white,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _produtos.length,
      itemBuilder: (context, index) {
        final produto = _produtos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(produto['imagemPath'] ?? 'assets/imagens/default_product.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produto['nome'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            produto['produtor'].toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${produto['quantidade'].toString()} Kgs',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '€${produto['preco'].toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _adicionarStock(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Restock',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
);
}
}