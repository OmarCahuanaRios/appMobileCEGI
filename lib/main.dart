// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_receptions/firebase.dart';
import 'dart:async';
import 'package:mobile_receptions/login.dart'; 

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyARxnyflEG4nOYhV51fgQbrTeVnCA07Dds',
       appId: '1:65740183129:ios:4554b485edf9092a0c4348', 
       messagingSenderId: '65740183129', 
       projectId: 'zox-receptions')
  );
  await FireBaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrimeraVista(),
    );
  }
}

class PrimeraVista extends StatefulWidget {
  @override
  _PrimeraVistaState createState() => _PrimeraVistaState();
}

class _PrimeraVistaState extends State<PrimeraVista> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            Text(
              'SISTEMA DE RECEPCIONES',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              'images/golf.jpg',
              width: 200,
              height: 200,
            ),
          ],
          
        ),
      ),
    );
  }
}
