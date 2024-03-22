import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VisitDetailScreen extends StatefulWidget {
  final String visitId;

  VisitDetailScreen({
    required this.visitId,
  });

  @override
  _VisitDetailScreenState createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  Map<String, dynamic> visit = {};

  @override
  void initState() {
    super.initState();
    getVisitById();
  }

  void getVisitById() async {
    String apiUrl = 'http://192.168.1.36:8090/visit/${widget.visitId}';
    final responseData = await http.get(Uri.parse(apiUrl));
    setState(() {
      visit = json.decode(responseData.body);
    });
  }

  @override
  Widget build(BuildContext context) {

    print("VISIT");
    print(visit);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Visita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        Text(
                'Fecha de Cita: ${visit['appointmentDate'] ?? ''}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
            Text(
              'Hora de Cita: ${visit['appointmentHour'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Estado: ${visit['status'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tipo de Visita: ${visit['visitType'] ?? ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Nombre del Visitante: ${visit['visitant'] != null ? visit['visitant']['firstName'] ?? '' : ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Apellido del Visitante: ${visit['visitant'] != null ? visit['visitant']['lastName'] ?? '' : ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tipo de Documento del Visitante: ${visit['visitant'] != null ? visit['visitant']['documentType'] ?? '' : ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Número de Documento del Visitante: ${visit['visitant'] != null ? visit['visitant']['documentId'] ?? '' : ''}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email del Visitante: ${visit['visitant'] != null ? visit['visitant']['email'] ?? '' : ''}',
              style: TextStyle(fontSize: 18.0),
            ),

          ],
        ),
      ),
    );
  }
}
