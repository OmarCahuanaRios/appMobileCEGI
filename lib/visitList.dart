import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_receptions/createVisit.dart';
import 'package:mobile_receptions/createWorker.dart';
import 'package:mobile_receptions/visitDetail.dart'; // Importa la pantalla VisitDetailScreen

class VisitListScreen extends StatefulWidget {
  final String enterpriseName;

  VisitListScreen({required this.enterpriseName});

  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  List visits = [];
  String? selectedArea;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    if (widget.enterpriseName != null) {
      getAllVisitsByEnterprise();
    }
  }

  void getAllVisitsByEnterprise() async {
    String apiUrl = 'http://192.168.1.36:8090/visit/enterprise/${widget.enterpriseName}';
    final responseData = await http.get(Uri.parse(apiUrl));

    if (responseData.statusCode == 200) {
      setState(() {
        visits = json.decode(responseData.body) ?? [];
      });
    } else {
      print("Error al obtener la lista de visitas. Código de estado: ${responseData.statusCode}");
    }
  }

  void _createWorker() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateVisitScreen(enterpriseName: widget.enterpriseName,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filtrar por:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      'Área:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    DropdownButton<String>(
                      value: selectedArea,
                      onChanged: (newValue) {
                        setState(() {
                          selectedArea = newValue!;
                        });
                      },
                      items: <String>['Área 1', 'Área 2', 'Área 3']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          'Estado:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        DropdownButton<String>(
                          value: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue!;
                            });
                          },
                          items: <String>['Activo', 'Inactivo']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                var visit = visits[index];
                if (selectedStatus != null &&
                    visit['status'] != selectedStatus) {
                  return SizedBox.shrink();
                }
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(
                      '${visit['visitant']['firstName']} ${visit['visitant']['lastName'] ?? ''}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Fecha: ${visit['appointmentDate']}     Hora: ${visit['appointmentHour']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitDetailScreen(visitId: visit['id'].toString()), // Pasa el ID de la visita
                        ),
                      );
                    },
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorker,
        child: Icon(Icons.add),
      ),
    );
  }
}
