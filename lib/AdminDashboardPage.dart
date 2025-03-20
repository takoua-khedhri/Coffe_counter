import 'package:flutter/material.dart';
import 'AjoutUser.dart'; // Importer la page AjoutUser
import 'loginPage.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
  title: Row(
    children: [
      Icon(
        Icons.coffee, // Icône de café
        color: Colors.white,
        size: 24, // Taille de l'icône
      ),
      SizedBox(width: 8), // Espacement entre l'icône et le texte
      Text(
        'Dashboard Administrateur',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400, // Texte plus fin
          color: Colors.white,
        ),
      ),
    ],
  ),
  backgroundColor: Colors.brown[300], // Couleur de l'AppBar
  automaticallyImplyLeading: true, // Ajoute un bouton de retour automatiquement
),

   body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.brown[400]!,
              Colors.brown[200]!
            ], // Teintes plus claires
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre principal
              SizedBox(height: 10),

              // Carte de gestion des employés
              Card(
                elevation: 6,
                color: Colors.brown[300], // Couleur plus claire
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Row pour le bouton "Consulter un utilisateur"
                      Row(
                        children: [
                          // Bouton pour consulter un utilisateur
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            icon: Icon(Icons.search, color: Colors.white),
                            label: Text(
                              'Consulter un utilisateur',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown[500],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16), // Espacement entre les boutons

                      // Row pour le bouton "Ajouter un utilisateur"
                      Row(
                        children: [
                          // Bouton pour ajouter un utilisateur
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Ajoutuser()),
                              );
                            },
                            icon: Icon(Icons.add, color: Colors.white),
                            label: Text(
                              'Ajouter un utilisateur',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown[500],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
