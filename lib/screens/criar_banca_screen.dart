import 'package:flutter/material.dart';

class CriarBancaScreen extends StatefulWidget {
  const CriarBancaScreen({super.key});

  @override
  State<CriarBancaScreen> createState() => _CriarBancaScreenState();
}

class _CriarBancaScreenState extends State<CriarBancaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _moradaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  String? _localizacaoSelecionada;

  void _criarBanca() {
    final nome = _nomeController.text;
    final morada = _moradaController.text;
    final descricao = _descricaoController.text;
    final localizacao = _localizacaoSelecionada ?? '';

    Navigator.pushNamed(
      context,
      '/banca-home',
      arguments: {
        'nomeBanca': nome,
        'descricao': descricao,
        'localizacao': morada,
        'coordenadas': '',
        'mercados': [],
        'criticas': [],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: PageView(
          scrollDirection: Axis.vertical,
          children: [
            _buildPage1(context),
            _buildPage2(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader("Criar Banca"),
          const SizedBox(height: 16),
          _buildTextField("Nome da banca", _nomeController),
          const SizedBox(height: 24),
          _buildSectionTitle("Detalhes"),
          _buildDropdown("Localização:"),
          const SizedBox(height: 12),
          _buildTextField("Morada:", _moradaController),
          const SizedBox(height: 24),
          _buildSectionTitle("Mercados Habituais"),
          _buildTextField("", TextEditingController()), // opcional
          const SizedBox(height: 12),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
            iconSize: 32,
            color: Colors.green[700],
          ),
          const SizedBox(height: 24),
          const Icon(Icons.keyboard_arrow_down, size: 36),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader("Criar Banca"),
          const SizedBox(height: 16),
          _buildSectionTitle("Imagens"),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Adicione imagens da banca", style: TextStyle(color: Colors.grey[700])),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (_) => _buildImagePlaceholder()),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Descrição"),
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
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset('assets/imagens/helloCornerLogo.png', height: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.settings, color: Colors.white),
        ],
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

  Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _localizacaoSelecionada,
          items: const [
            DropdownMenuItem(value: "Local 1", child: Text("Local 1")),
            DropdownMenuItem(value: "Local 2", child: Text("Local 2")),
          ],
          onChanged: (value) {
            setState(() {
              _localizacaoSelecionada = value;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.add_photo_alternate_outlined, size: 36),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descricaoController,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: "Descrição da banca...",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.green[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
