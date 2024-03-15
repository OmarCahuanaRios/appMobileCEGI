// main.dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mobile_receptions/login.dart'; 

void main() {
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
    
    // Retrasa la navegación a la segunda vista después de 3 segundos
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
