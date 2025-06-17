import 'package:flutter/material.dart';
import 'editar_banca_screen.dart';

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
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditarBancaScreen(
        nomeBanca: nomeBanca,
        descricao: descricao,
        localizacao: localizacao,
        coordenadas: coordenadas,
        mercados: mercados,
        criticas: criticas,
      ),
    ),
  );
},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
  height: 200,
  child: _ImagemCarousel(imagens: [
    'assets/imagens/quinta.jpeg',
    'assets/imagens/quinta2.jpeg',
    'assets/imagens/quinta3.jpeg',
  ]),
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

class _ImagemCarousel extends StatefulWidget {
  final List<String> imagens;

  const _ImagemCarousel({required this.imagens});

  @override
  State<_ImagemCarousel> createState() => _ImagemCarouselState();
}

class _ImagemCarouselState extends State<_ImagemCarousel> {
  final PageController _controller = PageController();
  int _paginaAtual = 0;

  void _avancar() {
    if (_paginaAtual < widget.imagens.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _voltar() {
    if (_paginaAtual > 0) {
      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.imagens.length,
          onPageChanged: (index) => setState(() => _paginaAtual = index),
          itemBuilder: (_, index) {
            return Image.asset(
              widget.imagens[index],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey,
                child: const Center(child: Text('Imagem não encontrada')),
              ),
            );
          },
        ),
        Positioned(
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: _voltar,
          ),
        ),
        Positioned(
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.white,
            onPressed: _avancar,
          ),
        ),
      ],
    );
  }
}
