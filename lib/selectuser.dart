import 'package:flutter/material.dart';
import 'loginPage.dart'; // Assurez-vous que ce fichier existe
import 'LoginAdmPage.dart'; // Assurez-vous que ce fichier existe

class SelectUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown[900]!, Colors.brown[700]!], // Arrière-plan plus foncé
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône principale
              Icon(Icons.coffee, size: 80, color: Colors.white),
              SizedBox(height: 20),

              // Titre
              Text(
                'Choisissez votre rôle',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),

              // Bouton Employé
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700], // Bouton plus foncé
                  foregroundColor: Colors.white, // Texte blanc
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                icon: Icon(Icons.work, color: Colors.white), // Icône employé
                label: Text(
                  'Utilisateur',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 20),

              // Bouton Administrateur
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdmPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800], // Bouton plus foncé
                  foregroundColor: Colors.white, // Texte blanc
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                icon: Icon(Icons.admin_panel_settings, color: Colors.white), // Icône admin
                label: Text(
                  'Administrateur',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
