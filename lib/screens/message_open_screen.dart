import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project/screens/rpc_service.dart';

class MessageOpenScreen extends StatefulWidget {
  final String name;
  final String lastMessage;

  const MessageOpenScreen({
    Key? key,
    required this.name,
    required this.lastMessage,
  }) : super(key: key);

  @override
  _MessageOpenScreenState createState() => _MessageOpenScreenState();
}

class _MessageOpenScreenState extends State<MessageOpenScreen> {
  final RpcService rpc = RpcService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final LayerLink _emojiLink = LayerLink();
  OverlayEntry? _emojiOverlay;

  @override
  void initState() {
    super.initState();
    _messages.add({"text": widget.lastMessage, "isSentByMe": true});
  }

  final List<String> _autoReplies = [
    "Olá! Como posso ajudar?",
    "Vou verificar e respondo já.",
    "Obrigado pela mensagem!",
    "Pode enviar mais detalhes?",
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"text": text, "isSentByMe": true});
    });
    _controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      final reply = (_autoReplies..shuffle()).first;
      setState(() {
        _messages.add({"text": reply, "isSentByMe": false});
      });
    });
  }

  void _toggleEmojiPicker() {
    if (_emojiOverlay != null) {
      _emojiOverlay!.remove();
      _emojiOverlay = null;
      return;
    }

    _emojiOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: 240,
        child: CompositedTransformFollower(
          link: _emojiLink,
          showWhenUnlinked: false,
          offset: const Offset(0, -250),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Wrap(
              children: ['😀', '😁', '😂', '🤣', '😊', '😍', '😢', '😎', '😡']
                  .map((emoji) => InkWell(
                        onTap: () {
                          _controller.text += emoji;
                          _emojiOverlay?.remove();
                          _emojiOverlay = null;
                          setState(() {}); // atualizar o widget se necessário
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(emoji, style: const TextStyle(fontSize: 24)),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_emojiOverlay!);
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
              reverse: false,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg["isSentByMe"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: msg["isSentByMe"]
                          ? Colors.white
                          : const Color(0xFF25D366),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: msg["isSentByMe"]
                            ? const Radius.circular(20)
                            : const Radius.circular(0),
                        bottomRight: msg["isSentByMe"]
                            ? const Radius.circular(0)
                            : const Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      msg["text"],
                      style: TextStyle(
                        color:
                            msg["isSentByMe"] ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CompositedTransformTarget(
            link: _emojiLink,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.grey),
                    onPressed: _toggleEmojiPicker,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Mensagem",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      splashColor: Colors.green[900],
                      highlightColor: Colors.green[900],
                      onTap: _sendMessage,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.send, color: Color(0xFF075E54)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
