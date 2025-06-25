import 'package:flutter/material.dart';

class ProductsListScreen extends StatelessWidget {
  final List<Map<String, String>> products;

  const ProductsListScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos os Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']!),
            trailing: Text(
              product['value']!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Dados para cada mês com tipos explícitos (ordenados do mais recente para o mais antigo)
  final List<Map<String, dynamic>> _monthlyData = [
    {
      'name': 'Março',
      'totalSales': 280,
      'weeklySales': [550.0, 700.0, 650.0, 720.0],
    },
    {
      'name': 'Fevereiro',
      'totalSales': 312,
      'weeklySales': [600.0, 750.0, 800.0, 690.0],
    },
    {
      'name': 'Janeiro',
      'totalSales': 256,
      'weeklySales': [520.0, 680.0, 720.0, 610.0],
    },
  ];

  // Lista completa de produtos
  final List<Map<String, String>> _allProducts = [
    {'name': 'Alicce', 'value': '98'},
    {'name': 'Batata', 'value': '72'},
    {'name': 'Tomate', 'value': '63'},
    {'name': 'Cebola', 'value': '58'},
    {'name': 'Alho', 'value': '47'},
    {'name': 'Cenoura', 'value': '42'},
    {'name': 'Repolho', 'value': '38'},
  ];

  int _currentMonthIndex = 0; // Começa no mês mais recente (índice 0)
  late double _maxSales;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _updateMaxSales();
  }

  void _updateMaxSales() {
    final sales = _monthlyData[_currentMonthIndex]['weeklySales'] as List<double>;
    _maxSales = sales.reduce((a, b) => a > b ? a : b);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentMonthIndex = index;
      _updateMaxSales();
    });
  }

  void _showAllProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsListScreen(products: _allProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = _monthlyData[_currentMonthIndex];
    final weeklySales = currentMonth['weeklySales'] as List<double>;
    final totalSales = currentMonth['totalSales'] as int;

    // Calcular a média semanal
    final weeklySum = weeklySales.fold<double>(0, (sum, value) => sum + value);
    final weeklyAverage = weeklySum / weeklySales.length;
    final lastMonthAverage = _currentMonthIndex < _monthlyData.length - 1 
        ? (_monthlyData[_currentMonthIndex + 1]['weeklySales'] as List<double>)
            .fold<double>(0, (sum, value) => sum + value) / 4
        : 600.0;
    final percentageChange = ((weeklyAverage - lastMonthAverage) / lastMonthAverage * 100);
    final percentageText = '${percentageChange.toStringAsFixed(1)}%';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de vendas mensais
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total de Vendas',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currentMonth['name'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$totalSales',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.trending_up, size: 16, color: Colors.green),
                              SizedBox(width: 4),
                              Text(
                                '+12% último mês',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Média semanal
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Média Semanal',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            '${weeklyAverage.toStringAsFixed(0)} vendas/semana',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$percentageText em relação ao mês passado',
                            style: TextStyle(
                              color: percentageChange >= 0 
                                  ? Colors.green 
                                  : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Gráfico de barras com navegação por gesto
                    SizedBox(
                      height: 140,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _monthlyData.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final monthData = _monthlyData[index];
                          final weeklySales = monthData['weeklySales'] as List<double>;
                          
                          return Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBar(weeklySales[0], 'Sem 1', index == _currentMonthIndex ? 0 : -1),
                                _buildBar(weeklySales[1], 'Sem 2', index == _currentMonthIndex ? 1 : -1),
                                _buildBar(weeklySales[2], 'Sem 3', index == _currentMonthIndex ? 2 : -1),
                                _buildBar(weeklySales[3], 'Sem 4', index == _currentMonthIndex ? 3 : -1),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Indicadores de página
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(
                        _monthlyData.length,
                        (index) => Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentMonthIndex == index
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Produtos mais vendidos
            const Text(
              'Produtos Mais Vendidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              child: Column(
                children: [
                  _buildProductItem(name: _allProducts[0]['name']!, value: _allProducts[0]['value']!),
                  const Divider(height: 1),
                  _buildProductItem(name: _allProducts[1]['name']!, value: _allProducts[1]['value']!),
                  const Divider(height: 1),
                  _buildProductItem(name: _allProducts[2]['name']!, value: _allProducts[2]['value']!),
                  TextButton(
                    onPressed: () => _showAllProducts(context),
                    child: const Text('Ver Todos'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Medalhas
            const Text(
              'Medalhas Conquistadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                _MedalItem(name: 'Verdeador do Mês', value: '100'),
                _MedalItem(name: 'Avaliações', value: ''),
                _MedalItem(name: 'Entregador Pontual', value: ''),
                _MedalItem(name: 'Escolha do consumidor', value: '500'),
                _MedalItem(name: 'Vendas', value: '2022'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double value, String label, int currentWeekIndex) {
    final heightFactor = value / _maxSales;
    final isCurrentWeek = currentWeekIndex == 3;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Container(
          width: 25,
          height: 70 * heightFactor,
          decoration: BoxDecoration(
            color: isCurrentWeek ? Colors.green : Colors.green.withValues(),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4))
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrentWeek ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem({required String name, required String value}) {
    return ListTile(
      title: Text(name),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MedalItem extends StatelessWidget {
  final String name;
  final String value;

  const _MedalItem({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}