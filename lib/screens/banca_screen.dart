import 'package:flutter/material.dart';

class BancaScreen extends StatelessWidget {
  final String nomeBanca;
  final String descricao;
  final String localizacao;
  final String coordenadas;
  final List<String> mercados;
  final List<Map<String, dynamic>> criticas;

  const BancaScreen({
    super.key,
    required this.nomeBanca,
    required this.descricao,
    required this.localizacao,
    required this.coordenadas,
    required this.mercados,
    required this.criticas,
  });

  // Construtor nomeado com dados mock para usar no main
  const BancaScreen.defaultScreen({super.key})
      : nomeBanca = 'Quinta Zacarias',
        descricao = 'Uma banca de produtos frescos e orgânicos.',
        localizacao = 'Rua das Flores, 123',
        coordenadas = '40.7128, -74.0060',
        mercados = const ['Mercado Municipal', 'Feira de Agricultores'],
        criticas = const [
          {
            'autor': 'João',
            'comentario': 'Produtos excelentes!',
            'estrelas': 5,
          },
          {
            'autor': 'Maria',
            'comentario': 'Muito bom atendimento!',
            'estrelas': 4,
          },
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeBanca),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // ação de editar banca
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/imagens/quinta.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text('Descrição', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(descricao),
            const SizedBox(height: 16),
            Text('Detalhes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Localização: $localizacao'),
            Text('Coordenadas: $coordenadas'),
            const SizedBox(height: 16),
            Text('Mercados Habituais', style: Theme.of(context).textTheme.titleLarge),
            ...mercados.map((mercado) => Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('• $mercado'),
            )),
            const SizedBox(height: 16),
            Text('Críticas', style: Theme.of(context).textTheme.titleLarge),
            ...criticas.map((c) => Card(
              margin: const EdgeInsets.only(top: 8),
              child: ListTile(
                title: Text(c['autor']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['comentario']),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (c['estrelas'] ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          size: 20,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
