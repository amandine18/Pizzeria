import 'package:flutter/material.dart';
import 'package:pizzeria/ui/share/bottom_navigation_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilPage extends StatefulWidget {
  const UserProfilPage({super.key});

  @override
  State<UserProfilPage> createState() => _UserProfilPageState();
}

class _UserProfilPageState extends State<UserProfilPage> {
  String _name = "";
  String _email = "";
  String _address = "";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //Charge les données utilisateur depuis localStorage
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "";
      _email = prefs.getString('email') ?? "";
      _address = prefs.getString('address') ?? "";
    });
  }

  //Enregistre les données utilisateur dans localStorage
  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setString('address', _address);
  }

  // Afficher la boîte de dialogue pour modifier les données
  void _editUserData() {
    _nameController.text = _name;
    _emailController.text = _email;
    _addressController.text = _address;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le profil'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Adresse'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _name = _nameController.text;
                  _email = _emailController.text;
                  _address = _addressController.text;
                });
                _saveUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom : ${_name.isEmpty ? "Non renseigné" : _name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email : ${_email.isEmpty ? "Non renseigné" : _email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Adresse : ${_address.isEmpty ? "Non renseignée" : _address}',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _editUserData,
                child: const Text('Modifier le profil'),
              ),
            ),
          ]
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(3),
    );
  }
}