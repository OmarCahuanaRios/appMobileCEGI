import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisitanteDetailScreen extends StatefulWidget {
  final String visitanteId;

  VisitanteDetailScreen({required this.visitanteId});

  @override
  _VisitanteDetailScreenState createState() => _VisitanteDetailScreenState();
}

class _VisitanteDetailScreenState extends State<VisitanteDetailScreen> {
  Map<String, dynamic> visitante = {};

  @override
  void initState() {
    super.initState();
    getVisitanteById();
  }

  void getVisitanteById() async {
    String apiUrl = 'http://192.168.1.36:8090/visitant/${widget.visitanteId}';
    final responseData = await http.get(Uri.parse(apiUrl));
    setState(() {
      visitante = json.decode(responseData.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Visitante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: ${visitante['firstName'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Apellido: ${visitante['lastName'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: ${visitante['email'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tipo de Documento: ${visitante['documentType'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Número de Documento: ${visitante['documentId'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Nombre de la Empresa: ${visitante['enterpriseName'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
