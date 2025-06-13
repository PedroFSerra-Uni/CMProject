import 'package:flutter/material.dart';

// Simula o servidor RPC
class RpcService {
  Future<String> sendMessage(String user, String message) async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Resposta padrão se não encontrar
    final lowerMsg = message.toLowerCase();
   
   // Lista de padrões de saudação
    final greetings = ['oi', 'olá', 'ola', 'bom dia', 'boa tarde', 'boa noite'];
    final howAreYou = ['tudo bem?', 'como estás?', 'como vai?', 'como está?'];
    final goodbye = ['adeus', 'tchau', 'até logo', 'até mais'];

    if (greetings.contains(lowerMsg)) {
      return 'Olá! Como posso ajudar?';
    } else if (howAreYou.contains(lowerMsg)) {
      return 'Tudo ótimo, e com você?';
    } else if (goodbye.contains(lowerMsg)) {
      return 'Até logo! Foi bom falar contigo.';
    } else if (lowerMsg.contains('obrigado') || lowerMsg.contains('obrigada')) {
      return 'De nada! Qualquer coisa estou por aqui.';
    } else if (lowerMsg.contains('problema') || lowerMsg.contains('erro')) {
      return 'Pode explicar melhor o problema? Estou aqui para ajudar.';
    } else if (lowerMsg.contains('ficheiro') || lowerMsg.contains('documento')) {
      return 'Envie o ficheiro ou diga mais sobre o que precisa.';
    }

    return 'Não entendi, pode repetir?';
  }
}

class MessageOpenScreen extends StatefulWidget {
  final String name;

  const MessageOpenScreen({Key? key, required this.name}) : super(key: key);

  @override
  State<MessageOpenScreen> createState() => _MessageOpenScreenState();
}

class _MessageOpenScreenState extends State<MessageOpenScreen> {
  final RpcService rpc = RpcService();
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  bool _sending = false;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: _controller.text, isUser: true));
      _sending = true;
    });

    String reply = await rpc.sendMessage(widget.name, _controller.text);

    setState(() {
      _messages.add(_ChatMessage(text: reply, isUser: false));
      _sending = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCF8C6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: Text(widget.name),
        actions: const [
          Icon(Icons.attach_file),
          SizedBox(width: 16),
          Icon(Icons.more_vert),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.white : const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(color: msg.isUser ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_sending) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.emoji_emotions_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Mensagem",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  splashColor: Colors.green[900],
                  highlightColor: Colors.green[900],
                  onTap: _sending ? null : _sendMessage,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.send, color: Color(0xFF075E54)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
