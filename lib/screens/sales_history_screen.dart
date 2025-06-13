import 'package:flutter/material.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  // Lista de vendas (exemplo)
  List<Map<String, dynamic>> salesItems = [
    {
      'name': 'Batata-Doce',
      'producer': 'Produtor',
      'rating': 5,
      'price': 5.99,
      'image': 'batata_doce',
    },
    {
      'name': 'Pimentos',
      'producer': 'Produtor',
      'rating': 5,
      'price': 10.99,
      'image': 'pimentos',
    },
    {
      'name': 'Tomate',
      'producer': 'Produtor',
      'rating': 4,
      'price': 3.99,
      'image': 'tomate',
    },
    {
      'name': 'Cenoura',
      'producer': 'Produtor',
      'rating': 5,
      'price': 2.99,
      'image': 'cenoura',
    },
    {
      'name': 'Alface',
      'producer': 'Produtor',
      'rating': 4,
      'price': 1.99,
      'image': 'alface',
    },
  ];

  // Índices selecionados para remoção
  List<int> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Vendas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        actions: [
          if (selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _showDeleteConfirmation,
            ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de seleção quando itens estão selecionados
          if (selectedItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              color: Colors.red.withOpacity(0.1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${selectedItems.length} item(s) selecionado(s)',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextButton(
                      onPressed: _showDeleteConfirmation,
                      child: const Text(
                        'REMOVER',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    fit: FlexFit.loose,
                    child: TextButton(
                      onPressed: () => setState(() => selectedItems = []),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: salesItems.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = salesItems[index];
                final isSelected = selectedItems.contains(index);
                return _buildProductCard(item, index, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item, int index, bool isSelected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do produto (placeholder)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.shopping_bag,
                    size: 40,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('Por → ',
                              style: TextStyle(color: Colors.grey, fontSize: 14)),
                          Text(
                            item['producer'],
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 10),
                          _buildRatingStars(item['rating']),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '€${item['price'].toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () => _restockProduct(item),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                'Restock',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ícone de seleção/remoção
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedItems.remove(index);
                  } else {
                    selectedItems.add(index);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.delete_outline,
                  color: isSelected ? Colors.white : Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (starIndex) {
        return Icon(
          starIndex < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  void _showDeleteConfirmation() {
    if (selectedItems.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Remoção'),
        content: Text(
          'Tem certeza que deseja remover ${selectedItems.length} item(s) do histórico?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Ordena em ordem decrescente para remover corretamente
              selectedItems.sort((a, b) => b.compareTo(a));
              
              setState(() {
                for (int index in selectedItems) {
                  salesItems.removeAt(index);
                }
                selectedItems = [];
              });
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${selectedItems.length} item(s) removido(s)'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _restockProduct(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restock solicitado para ${product['name']}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrar Histórico',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('Todos os itens', true),
              _buildFilterOption('Últimos 7 dias', false),
              _buildFilterOption('Último mês', false),
              _buildFilterOption('Itens mais vendidos', false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Aplicar Filtros'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, bool selected) {
    return ListTile(
      title: Text(title),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {},
    );
  }
}