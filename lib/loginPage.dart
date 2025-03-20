import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Pour Realtime Database
import 'NbCafePage.dart'; // Import de la page vers laquelle l'utilisateur est redirigé après connexion réussie
import 'globals.dart'; // Import du fichier contenant la variable globale

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        // Référence à la base de données Firebase
        DatabaseReference ref = FirebaseDatabase.instance.ref('employe');

        // Récupérer les données de l'employé
        DatabaseEvent event = await ref.orderByChild('username').equalTo(username).once();
        DataSnapshot snapshot = event.snapshot;

        // Vérifier si des données existent pour cet utilisateur
        if (snapshot.exists) {
          // Parcourir les résultats (normalement un seul employé correspondant)
          bool isPasswordCorrect = false;
          Map<dynamic, dynamic> employeData = snapshot.value as Map<dynamic, dynamic>;

          employeData.forEach((key, value) {
            if (value['password'] == password) {
              isPasswordCorrect = true;
            }
          });

          if (isPasswordCorrect) {
            // Connexion réussie
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connexion réussie !'),
                backgroundColor: Colors.brown[500],
              ),
            );

            // Stocker l'username dans la variable globale
            Globals.username = username;

            // Rediriger vers la page NbCafePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NbCafePage()),
            );
          } else {
            // Mot de passe incorrect
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mot de passe incorrect'),
                backgroundColor: Colors.red[400],
              ),
            );
          }
        } else {
          // Utilisateur non trouvé
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nom d\'utilisateur incorrect'),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      } catch (e) {
        print("Erreur : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Une erreur est survenue. Veuillez réessayer.'),
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
                        'Connexion',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Champ Nom d'utilisateur
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
                          if (value!.isEmpty) {
                            return 'Veuillez entrer votre nom d\'utilisateur';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Champ Mot de passe
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
                          if (value!.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      // Bouton de connexion
                      ElevatedButton(
                        onPressed: _login,
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
                          'Se connecter',
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