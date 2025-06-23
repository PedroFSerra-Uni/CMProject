// messagehome_screen.dart
import 'package:flutter/material.dart';
import 'message_open_screen.dart';

class MessageHomeScreen extends StatelessWidget {
  
  final List<Map<String, String>> messages = [
    {"name": "Joana Silva", "lastMessage": "Até já!", "time": "12:45"},
    {"name": "Carlos Rocha", "lastMessage": "Enviei os ficheiros", "time": "11:20"},
    {"name": "Ana Torres", "lastMessage": "Bom dia!", "time": "10:01"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mensagens"),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: Colors.green[600],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(messages[index]["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(messages[index]["lastMessage"]!),
              trailing: Text(messages[index]["time"]!, style: const TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                   builder: (_) => MessageOpenScreen(
                        name: messages[index]["name"]!,
                        lastMessage: messages[index]["lastMessage"]!,
),                      
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
