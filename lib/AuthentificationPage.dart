import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'LoginPage.dart'; // Importer la page de connexion

class AuthentificationPage extends StatefulWidget {
  @override
  _AuthentificationPageState createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref(); // Connexion à Realtime Database

  void _signUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        // Vérifier si le nom d'utilisateur existe déjà
        DataSnapshot snapshot = (await _database.child("employe").orderByChild("username").equalTo(_usernameController.text).once()).snapshot;

        if (snapshot.value != null) {
          // Le nom d'utilisateur existe déjà
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ce nom d\'utilisateur existe déjà.')),
          );
          return;
        }

        // Générer un ID unique pour chaque employé
        String employeId = _database.child("employe").push().key!;

        // Préparer les données à enregistrer
        Map<String, dynamic> employeData = {
          'username': _usernameController.text,
          'password': _passwordController.text, // ⚠️ Ne pas stocker en clair en production
          'nbcafe': 0, // Initialisation à 0
        };

        // Ajouter l'utilisateur sous le nœud "employe" avec son ID unique
        await _database.child("employe").child(employeId).set(employeData);

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employé ajouté avec succès !')),
        );

        // Attendre 2 secondes avant de rediriger
        await Future.delayed(Duration(seconds: 2));

        // Effacer les champs après l'inscription
        _usernameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        // Rediriger vers la page de connexion après inscription
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } catch (e) {
        print('Erreur lors de l\'ajout de l\'employé : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Une erreur est survenue. Réessayez.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 40),

              // Champ Username
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),

              // Champ Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),

              SizedBox(height: 10),

              // Champ Confirmation Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Bouton d'inscription
              ElevatedButton(
                onPressed: _signUp,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all<Size>(Size(260, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Text(
                  'S\'inscrire',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}