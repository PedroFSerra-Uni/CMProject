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

  double ratingAverage = 0.0;
  int ratingCount = 0;

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

        // ⭐ Rating
        if (data.containsKey('ratingList') && data['ratingList'] is List) {
          final List<dynamic> ratings = data['ratingList'];
          ratingCount = ratings.length;
          if (ratingCount > 0) {
            final sum = ratings.fold<num>(0, (acc, val) => acc + (val ?? 0));
            ratingAverage = sum / ratingCount;
          }
        } else {
          // Alternativa: usa campos ratingAvg e ratingCount se existirem diretamente
          ratingAverage = (data['ratingAvg'] ?? 0).toDouble();
          ratingCount = data['ratingCount'] ?? 0;
        }
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
              child: Text(
                name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // ⭐ Avaliação do Produtor
            const Text(
              'Avaliação do Produtor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  ratingCount > 0 ? '${ratingAverage.toStringAsFixed(1)} / 5' : 'Sem avaliações',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                if (ratingCount > 0)
                  Text(
                    '($ratingCount avaliação${ratingCount > 1 ? 's' : ''})',
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
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
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
