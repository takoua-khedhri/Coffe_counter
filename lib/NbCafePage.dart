import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';  // Correct import for Firebase Realtime Database
import 'globals.dart'; // Import du fichier contenant la variable globale

class NbCafePage extends StatefulWidget {
  @override
  _NbCafePageState createState() => _NbCafePageState();
}

class _NbCafePageState extends State<NbCafePage> {
  String username = "Utilisateur"; // Valeur par défaut
  int nbcafe = 0; // Valeur par défaut
  late DatabaseReference userRef;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Récupération des données utilisateur et écoute en temps réel
  Future<void> fetchUserData() async {
    try {
      userRef = FirebaseDatabase.instance.ref('employe');

      // Recherche de l'utilisateur dans la base de données Realtime Database
      DatabaseEvent event = await userRef.orderByChild('username').equalTo(Globals.username).once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        // Convertir les données en Map
        Map<dynamic, dynamic> userData = snapshot.value as Map<dynamic, dynamic>;

        // Parcourir les résultats (normalement un seul utilisateur correspondant)
        userData.forEach((key, value) {
          if (value['username'] == Globals.username) {
            setState(() {
              username = value['username'] ?? "Utilisateur";
              nbcafe = value['nbcafe'] ?? 0;
            });
          }
        });
      } else {
        print("Aucun utilisateur trouvé avec cet username.");
      }

      // Écouter les changements en temps réel pour le nombre de cafés
      userRef
          .orderByChild('username')
          .equalTo(Globals.username)
          .onChildChanged.listen((event) {
        final updatedCafeCount = event.snapshot.child('nbcafe').value;
        setState(() {
          // Tentative de conversion du nombre de cafés en entier
          nbcafe = updatedCafeCount != null ? int.tryParse(updatedCafeCount.toString()) ?? 0 : 0;
        });
      });
      
    } catch (e) {
      print("Erreur lors du chargement des données : $e");
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icône de café
                    Icon(
                      Icons.coffee,
                      size: 80,
                      color: Colors.brown[800],
                    ),
                    SizedBox(height: 20),

                    // Message de bienvenue
                    Text(
                      "Bonjour $username",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Nombre de cafés en grand
                    Text(
                      nbcafe.toString(), // Convertir en String pour l'affichage
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Texte descriptif
                    Text(
                      "Nombre de cafés consommés",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
