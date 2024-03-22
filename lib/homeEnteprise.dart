import 'package:flutter/material.dart';
import 'package:mobile_receptions/visitList.dart';
import 'package:mobile_receptions/workerList.dart';
import 'package:mobile_receptions/visitantList.dart';

class HomeEnterpriseScreen extends StatelessWidget {
  final String enterpriseName;

  HomeEnterpriseScreen({required this.enterpriseName}){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bienvenido ' + '$enterpriseName',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
               Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisitListScreen(enterpriseName: enterpriseName)),
                    );
              },
              child: Text('Visitas'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkerListScreen(enterpriseName: enterpriseName)),
                    );
              },
              child: Text('Trabajadores'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisitantListScreen(enterpriseName: enterpriseName)),
                    );
              },
              child: Text('Visitantes'),
            ),
          ],
        ),
      ),
    );
  }
}
