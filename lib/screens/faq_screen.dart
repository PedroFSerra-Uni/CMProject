import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  // Lista de perguntas e respostas
  final List<Map<String, String>> faqItems = [
    {
      'question': '1. Como posso criar a minha banca na plataforma?',
      'answer': 'Basta criar uma conta de produtor, preencher os dados da tua quinta e adicionar pelo menos um produto. Depois disso, a tua banca estará visível na plataforma.'
    },
    {
      'question': '2. Como edito ou removo um produto da minha banca?',
      'answer': 'Na área da tua banca, clica no produto que queres editar ou remover. Na página de detalhes do produto, encontrarás as opções "Editar" e "Remover".'
    },
    {
      'question': '3. A HelloFarmer cobra alguma comissão sobre as vendas?',
      'answer': 'Sim, cobramos uma pequena comissão de 5% sobre cada venda realizada através da plataforma. Esta comissão ajuda a manter e melhorar o nosso serviço.'
    },
    {
      'question': '4. Como funcionam as entregas? Tenho de as fazer eu?',
      'answer': 'Podes escolher entre duas opções: entregas feitas por ti ou através do nosso serviço de entregas parceiro. Se escolheres fazer as entregas, podes definir o teu próprio raio de entrega.'
    },
    {
      'question': '5. Posso indicar zonas específicas para entrega?',
      'answer': 'Sim, na configuração da tua banca podes definir zonas específicas onde estás disposto a entregar. Podes adicionar códigos postais ou áreas geográficas específicas.'
    },
  ];

  // Controla quais itens estão expandidos
  List<bool> expandedItems = [];

  @override
  void initState() {
    super.initState();
    // Inicialmente, nenhum item está expandido
    expandedItems = List.generate(faqItems.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perguntas Frequentes',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _buildFAQItem(faqItems[index], index);
        },
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          setState(() {
            expandedItems[index] = !expandedItems[index];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['question']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    expandedItems[index]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
              if (expandedItems[index])
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    item['answer']!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}