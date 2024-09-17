import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_receptions/visitantDetail.dart';

class VisitantListScreen extends StatefulWidget {
  String enterpriseName;

  VisitantListScreen({required this.enterpriseName}){}
  @override
  _VisitantListScreenState createState() => _VisitantListScreenState();
}

class _VisitantListScreenState extends State<VisitantListScreen> {
  List<dynamic> visitantes = [];

  @override
  void initState() {
    super.initState();
    getAllVisitantes();
  }

  void getAllVisitantes() async {
    String apiUrl = 'http://192.168.1.36:8090/visitant/enterprise/${widget.enterpriseName}';
    final responseData = await http.get(Uri.parse(apiUrl));
    if (responseData.statusCode == 200) {
      setState(() {
        visitantes = json.decode(responseData.body) ?? [];
      });
    } else {
      print("Error al obtener la lista de visitantes. Código de estado: ${responseData.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("VISITANTES");
    print(visitantes);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Visitantes'),
      ),
      body: ListView.builder(
        itemCount: visitantes.length,
        itemBuilder: (context, index) {
          var visitante = visitantes[index];
          return Card(
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('${visitante['firstName']} ${visitante['lastName'] ?? ''}'),
               subtitle: Text('DNI: ${visitante['documentId']}'),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitanteDetailScreen(
                            visitantId: visitante['id'].toString(),
                          ),
                        ),
                      );
              },
            ),
          );
        },
      ),
    );
  }
}
