import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'AdminDashboardPage.dart'; // Assurez-vous que cette page existe

class AdmPage extends StatefulWidget {
  @override
  _AdmPageState createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _validateAdminCredentials() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      try {
        // Récupérer les informations saisies
        String username = _usernameController.text;
        String password = _passwordController.text;

        // Référence à la base de données Firebase
        DatabaseReference adminRef = FirebaseDatabase.instance.ref('administrateur');
        
        // Récupérer les données de l'administrateur
        DatabaseEvent event = await adminRef.once();
        DataSnapshot snapshot = event.snapshot;

        // Vérifier si des données existent pour cet utilisateur
        if (snapshot.exists) {
          // Extraire les données de l'administrateur
          Map<dynamic, dynamic> adminData = snapshot.value as Map<dynamic, dynamic>;

          // Vérifier les identifiants
          if (adminData['username'] == username && adminData['password'] == password) {
            // Connexion réussie
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connexion réussie !'),
                backgroundColor: Colors.brown[500],
              ),
            );

            // Rediriger vers la page du tableau de bord admin
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboardPage()),
            );
          } else {
            // Identifiants incorrects
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Nom d\'utilisateur ou mot de passe incorrect'),
                backgroundColor: Colors.red[400],
              ),
            );
          }
        } else {
          // Aucun utilisateur trouvé
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Nom d\'utilisateur ou mot de passe incorrect'),
              backgroundColor: Colors.red[400],
            ),
          );
        }
      } catch (e) {
        print('Erreur lors de la vérification des identifiants : $e');
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
                        'Connexion Admin',
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
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      // Bouton de connexion
                      ElevatedButton(
                        onPressed: _validateAdminCredentials,
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