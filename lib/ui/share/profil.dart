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

  final _formKey = GlobalKey<FormState>();
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
    //SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "";
      _email = prefs.getString('email') ?? "";
      _address = prefs.getString('address') ?? "";

      _nameController.text = _name;
      _emailController.text = _email;
      _addressController.text = _address;
    });
  }

  //Enregistre les données utilisateur dans localStorage
  Future<void> _saveUserData() async {
    //SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _name);
    await prefs.setString('email', _email);
    await prefs.setString('address', _address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom ne peut pas être vide';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'email ne peut pas être vide';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Veuillez entrer un email valide';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Adresse',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'adresse ne peut pas être vide';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _name = _nameController.text;
                            _email = _emailController.text;
                            _address = _addressController.text;
                          });
                          _saveUserData();
                        }
                      },
                      child: Text('Sauvegarder'),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(3),
    );
  }
}