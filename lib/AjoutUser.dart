import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';  // Importer le package Realtime Database

class Ajoutuser extends StatefulWidget {
  @override
  _AjoutuserState createState() => _AjoutuserState();
}

class _AjoutuserState extends State<Ajoutuser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();  // Référence à la base de données Realtime

  void _signUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        // Vérifier si le nom d'utilisateur existe déjà
        DataSnapshot snapshot = (await _databaseRef.child("employe").orderByChild("username").equalTo(_usernameController.text).once()).snapshot;

        if (snapshot.value != null) {
          // Le nom d'utilisateur existe déjà
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ce nom d\'utilisateur existe déjà.'),
              backgroundColor: Colors.red[400],
            ),
          );
          return;
        }

        // Préparer les données à enregistrer dans Realtime Database
        Map<String, dynamic> employeData = {
          'username': _usernameController.text,
          'password': _passwordController.text, // ⚠️ Attention : en production, ne pas stocker les mots de passe en clair !
          'nbcafe': 0, // Initialisation à 0
        };

        // Ajouter l'utilisateur à la collection "employe" dans Realtime Database
        await _databaseRef.child('employe').push().set(employeData);

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Employé ajouté avec succès !'),
            backgroundColor: Colors.brown[500],
          ),
        );

        // Effacer les champs après l'inscription
        _usernameController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
      } catch (e) {
        print('Erreur lors de l\'ajout de l\'employé : $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Une erreur est survenue. Réessayez.'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown[800]!, Colors.brown[400]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Icône de café
                      Icon(
                        Icons.coffee,
                        size: 80,
                        color: Colors.brown[800],
                      ),
                      SizedBox(height: 20),

                      // Titre
                      Text(
                        'Ajouter un Employé',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Champ Username
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Nom d\'utilisateur',
                          labelStyle: TextStyle(color: Colors.brown[800]),
                          prefixIcon: Icon(Icons.person, color: Colors.brown[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.brown, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.brown[50],
                        ),
                       validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un nom d\'utilisateur';
  }
  if (!RegExp(r'^[A-Z]').hasMatch(value)) {
    return 'Le nom doit commencer par une majuscule';
  }
  return null;
},

                      ),
                      SizedBox(height: 20),

                      // Champ Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(color: Colors.brown[800]),
                          prefixIcon: Icon(Icons.lock, color: Colors.brown[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.brown, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.brown[50],
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
                      SizedBox(height: 20),

                      // Champ Confirmation Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          labelStyle: TextStyle(color: Colors.brown[800]),
                          prefixIcon: Icon(Icons.lock, color: Colors.brown[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.brown, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.brown[50],
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      // Bouton d'inscription
                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.brown[900],
                        ),
                        child: Text(
                          'Ajouter',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}