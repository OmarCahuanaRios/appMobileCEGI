import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WorkerDetailScreen extends StatefulWidget {
  final String workerId;

  WorkerDetailScreen({required this.workerId});

  @override
  _WorkerDetailScreenState createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  Map<String, dynamic> worker = {};

  @override
  void initState() {
    super.initState();
    getWorkerById();
  }

  void getWorkerById() async {
    String apiUrl = 'http://192.168.1.36:8090/worker/${widget.workerId}';
    final responseData = await http.get(Uri.parse(apiUrl));
    if (responseData.statusCode == 200) {
      setState(() {
        worker = json.decode(responseData.body);
      });
      print("SÍ OBTENGO LA INFO");
    } else {
      print("ERROR DE WORKER");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Trabajador'),
      ),
      body: Center( // Envuelve la columna principal en un Center
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/worker_avatar.png'), // Aquí puedes proporcionar la ruta de la imagen del trabajador
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '${worker['firstName']} ${worker['lastName']}',
                    style: TextStyle(
                      fontSize: 24.0, // Tamaño del texto aumentado
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Celular: ${worker['phone']}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Tipo de Documento: ${worker['documentType']}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Número de Documento: ${worker['documentId']}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Email: ${worker['email']}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Estado: ${worker['status'] != null ? (worker['status'] ? 'Activo' : 'Inactivo') : 'Desconocido'}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Área: ${worker['area']}',
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
