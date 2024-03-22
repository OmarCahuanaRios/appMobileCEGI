import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_receptions/createVisit.dart';
import 'package:mobile_receptions/createWorker.dart';
import 'package:mobile_receptions/workerDetail.dart';

class VisitListScreen extends StatefulWidget {
  final String enterpriseName;

  VisitListScreen({required this.enterpriseName});

  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  List visits = [];
  String? selectedArea;
  String? selectedStatus; // Nuevo campo para almacenar el estado seleccionado

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
         print("ESTAS SON TODAS LAS VISITAS");
        visits = json.decode(responseData.body) ?? [];
         print(visits);
      });
    } else {
      print("Error al obtener la lista de trabajadores. Código de estado: ${responseData.statusCode}");
    }
  }

  void _createWorker() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateVisitScreen(enterpriseName: widget.enterpriseName,)),
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
                          items: <String>['Activo', 'Inactivo'] // Lista de estados
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
                // Aplicar filtro por estado
                if (selectedStatus != null &&
                    visit['status'] != selectedStatus) {
                  return SizedBox.shrink(); // Ocultar elemento si no coincide con el estado seleccionado
                }
                Icon iconData;
                Color iconColor = Colors.black;
                // Determinar el color del círculo según el estado de la visita
                switch (visit['status']) {
                          case 'Aceptado':
                            iconData = Icon(Icons.check); // Ícono de verificación (check) para estado Aceptado
                            iconColor = Colors.green;
                            break;
                          case 'Rechazado':
                            iconData = Icon(Icons.close); // Ícono de cierre (x) para estado Rechazado
                            iconColor = Colors.red;
                            break;
                          case 'Pendiente':
                            iconData = Icon(Icons.warning); // Ícono de advertencia (warning) para estado Pendiente
                            iconColor = Colors.yellow;
                            break;
                          default:
                            iconData = Icon(Icons.error); // Ícono de error por defecto
                        }
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      ListTile(
                        // Eliminamos CircleAvatar
                        title: Text(
                                '${visit['visitant']['firstName']} ${visit['visitant']['lastName'] ?? ''}',
                                style: TextStyle(fontWeight: FontWeight.bold), // Aplicar negrita al nombre del visitante
                              ),
                              subtitle: Text(
                                'Fecha: ${visit['appointmentDate']}     Hora: ${visit['appointmentHour']}',
                                style: TextStyle(fontWeight: FontWeight.bold), // Aplicar negrita a la fecha y hora
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkerDetailScreen(workerId: visit['id'].toString(),)),
                          );
                        },
                        trailing : Icon(
                          iconData.icon,
                          color: iconColor,
                        ),
                      ),
                      
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorker,
        child: Icon(Icons.add), // Utiliza el icono de añadir de la biblioteca de iconos de Flutter
      ),
    );
  }
}
