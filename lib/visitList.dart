import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_receptions/createVisit.dart';
import 'package:mobile_receptions/createWorker.dart';
import 'package:mobile_receptions/visitDetail.dart';

class VisitListScreen extends StatefulWidget {
  final String enterpriseName;
  final String role;

  VisitListScreen({required this.enterpriseName, required this.role});

  @override
  _VisitListScreenState createState() => _VisitListScreenState();
}

class _VisitListScreenState extends State<VisitListScreen> {
  List visits = [];
  List enterprises = [];
  bool isEnterprise = false;
  bool isAdmin = false;
  String? selectedDNI;
  String? selectedArea;
  String? selectedStatus;
  late TextEditingController _dniController;

  
  final Map<String, Color> statusColors = {
    'Aceptado': Color.fromARGB(255, 166, 255, 169),
    'Pendiente': Color.fromRGBO(243, 255, 181, 1),
    'Rechazado': Color.fromARGB(255, 255, 165, 165),
  };

  final Map<String, Color> statusIconColors = {
    'Aceptado': Color.fromARGB(255, 0, 255, 8),
    'Pendiente': Color.fromRGBO(212, 255, 0, 1),
    'Rechazado': Color.fromARGB(255, 255, 0, 0),
  };

  @override
  void initState() {
    super.initState();
    _dniController = TextEditingController();
    if (widget.enterpriseName != null) {
      if (widget.role == "ROLE_ENTERPRISE") {
        isEnterprise = true;
        getAllVisitsByEnterprise();
      }

      if (widget.role == "ROLE_ADMIN") {
        isAdmin = true;
        getAllVisits();
        getAllEnterprises();
      }
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  void getAllVisitsByEnterprise() async {
    String apiUrl =
        'http://192.168.1.36:8090/visit/enterprise/${widget.enterpriseName}';
    final responseData = await http.get(Uri.parse(apiUrl));

    if (responseData.statusCode == 200) {
      setState(() {
        visits = json.decode(responseData.body) ?? [];
      });
    } else {
      print(
          "Error al obtener la lista de visitas. Código de estado: ${responseData.statusCode}");
    }
  }

  void getAllEnterprises() async {
    String apiUrl = 'http://192.168.1.36:8090/enterprise';
    final responseData = await http.get(Uri.parse(apiUrl));
    if (responseData.statusCode == 200) {
      setState(() {
        enterprises = json.decode(responseData.body);
      });
    }
  }

  void getAllVisits() async {
    String apiUrl = 'http://192.168.1.36:8090/visit';
    final responseData = await http.get(Uri.parse(apiUrl));

    if (responseData.statusCode == 200) {
      setState(() {
        visits = json.decode(responseData.body) ?? [];
      });
    } else {
      print(
          "Error al obtener la lista de visitas. Código de estado: ${responseData.statusCode}");
    }
  }

  void _createVisit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateVisitScreen(
          enterpriseName: widget.enterpriseName,
        ),
      ),
    );
  }

  void filterVisits() {
    print("VISITAS SON");
    print(visits);
    for(var visit in visits){
      print("DNIS SON");
      print(visit['visitant']['documentId']);
    }
    List filteredVisits = List.from(visits);
    String dni = _dniController.text.trim();
    if (dni.isNotEmpty) {
      print("EL DNI VA SIENDO");
      print(dni);
      filteredVisits = filteredVisits.where((visit) {
        if( visit['visitant']['documentId'] == dni){
          filteredVisits.add(visit);
        }
        print("XD");
        print(visit);
          return visit['visitant']['documentId'] == dni;
        }).toList();
    }

    setState(() {
      visits = filteredVisits;
      print("NUEVAS VISITAS FILTRADAS SON");
      print(visits);
    });
  }

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'Aceptado':
        return Icons.check;
      case 'Pendiente':
        return Icons.warning;
      case 'Rechazado':
        return Icons.close;
      default:
        return Icons.arrow_forward_ios;
    }
  }

  Color _getColorForStatus(String status) {
    return statusIconColors.containsKey(status)
        ? statusIconColors[status]!
        : Colors.black;
  }

  Color _getBackgroundColorForStatus(String status) {
    return statusColors.containsKey(status)
        ? statusColors[status]!
        : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitas'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  if (isAdmin)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Empresa:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          child: DropdownButton<String>(
                            value: selectedArea,
                            onChanged: (newValue) {
                              setState(() {
                                selectedArea = newValue!;
                              });
                              filterVisits();
                            },
                            items: enterprises.map<DropdownMenuItem<String>>(
                                (enterprise) {
                              return DropdownMenuItem<String>(
                                value: enterprise['enterpriseName'],
                                child: Text(enterprise['enterpriseName']),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'DNI:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: _dniController,
                        onChanged: (newValue) {
                          filterVisits();
                        },
                        decoration: InputDecoration(
                          hintText: 'Ingrese el DNI',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: visits.length,
              itemBuilder: (context, index) {
                var visit = visits[index];
                if (selectedDNI != null &&
                    visit['visitant']['documentId'] != selectedDNI) {
                  return SizedBox.shrink();
                }
                return Card(
                  margin: EdgeInsets.all(10.0),
                  color: _getBackgroundColorForStatus(visit['status']),
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
                          builder: (context) => VisitDetailScreen(
                            visitId: visit['id'].toString(),
                          ),
                        ),
                      );
                    },
                    trailing: Icon(
                      _getIconForStatus(visit['status']),
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createVisit,
        child: Icon(Icons.add),
      ),
    );
  }
}
