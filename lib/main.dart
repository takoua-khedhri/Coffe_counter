import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'selectuser.dart';
import 'firebase_options.dart';  // Assure-toi d'importer ce fichier

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAb3P_DG7ba5M63VsdD3uetLxwzzUGIUAI",
        authDomain: "presence-c317d.firebaseapp.com",
        databaseURL:"https://presence-c317d-default-rtdb.firebaseio.com/",
        projectId: "presence-c317d",
        storageBucket: "presence-c317d.appspot.com",
        messagingSenderId: "235276295895",
        appId: "1:235276295895:web:5569e0bbcde25192649a92",
        measurementId: "G-76HFTC5H9K",
      ),
    );
  } catch (e) {
    print("Erreur Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectUser(),
    );
  }
}
