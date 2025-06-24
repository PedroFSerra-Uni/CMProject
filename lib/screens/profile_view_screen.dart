import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_edit_screen.dart'; // Importa o teu ficheiro de edição

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';
  String phone = '';
  String description = '';
  String farmName = '';
  String location = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        description = data['description'] ?? '';
        farmName = data['farmName'] ?? '';
        location = data['location'] ?? '';
      });
    }
  }

  Future<void> _goToEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
    );

    if (updated == true) {
      _loadProfileData(); // Atualiza os dados
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _goToEditProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.person, size: 60, color: Colors.green),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
            ),
            const SizedBox(height: 16),
            const Text('Descrição', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.agriculture),
              title: Text(farmName),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(location),
            ),
          ],
        ),
      ),
    );
  }
}
