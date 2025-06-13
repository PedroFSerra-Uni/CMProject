import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _priceValue = 150.0;
  bool _hasSearched = false;
  
  // Estrutura hierárquica de categorias
  final Map<String, Map<String, bool>> _categories = {
    'Materiais': {
      'Fertilizantes': false,
      'Ferramentas': false,
      'Suportes': false,
      'Sementes': false,
      'Outros': false,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Pesquise...'),
      ),
      drawer: _buildFiltersDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'O que procura?',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              ),
              onSubmitted: (value) => _performSearch(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Filtros',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categorias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Lista hierárquica de categorias
            ..._categories.keys.map((mainCategory) {
              final subCategories = _categories[mainCategory]!;
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(
                  mainCategory,
                  style: const TextStyle(fontSize: 16),
                ),
                children: [
                  ...subCategories.keys.map((subCategory) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        subCategory,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: subCategories[subCategory],
                      onChanged: (value) {
                        setState(() {
                          subCategories[subCategory] = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }).toList(),
                ],
              );
            }).toList(),
            
            const SizedBox(height: 20),
            const Text(
              'Preço?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('0€'),
                Expanded(
                  child: Slider(
                    value: _priceValue,
                    min: 0,
                    max: 300,
                    divisions: 6,
                    label: _priceValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _priceValue = value;
                      });
                    },
                  ),
                ),
                const Text('300€'),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                ),
                child: const Text('Confirmar'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched) {
      // Exibe mensagem inicial antes de qualquer pesquisa
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Pesquise o que quer encontrar no HelloFarmer',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Exibe resultados após pesquisa
    return Center(
      child: Text(
        'Resultados para "${_searchController.text}"',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  void _performSearch() {
    // Marca que o usuário já realizou uma pesquisa
    setState(() {
      _hasSearched = true;
    });
    
    print('Pesquisando por: ${_searchController.text}');
  }

  void _applyFilters() {
    final selectedSubCategories = [];
    for (var mainCategory in _categories.keys) {
      for (var subCategory in _categories[mainCategory]!.keys) {
        if (_categories[mainCategory]![subCategory] == true) {
          selectedSubCategories.add('$mainCategory/$subCategory');
        }
      }
    }
    
    print('Filtros aplicados:');
    print('Preço máximo: ${_priceValue.round()}€');
    print('Subcategorias: $selectedSubCategories');
    
    // Executa a pesquisa ao aplicar filtros
    _performSearch();
  }
}