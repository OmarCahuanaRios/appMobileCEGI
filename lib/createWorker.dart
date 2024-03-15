import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewWorkerScreen extends StatefulWidget {

  final String enterpriseName;
  NewWorkerScreen({required this.enterpriseName});


  @override
  _NewWorkerScreenState createState() => _NewWorkerScreenState();
}

class _NewWorkerScreenState extends State<NewWorkerScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  Map<String, dynamic> enterprise = {};
  String? _selectedDocumentType;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _documentNumber = '';
  String _area = '';

  void createWorker(String? documentType, String firstName, String lastName, String email, String documentId, String area) async {
    print("EMPRESITA ES");
    print(widget.enterpriseName);
    String apiUrl = 'http://192.168.1.36:8090/worker';
    String enterpriseUrl = 'http://192.168.1.36:8090/enterprise/name/${widget.enterpriseName}';
    final enterpriseResponse = await http.get(Uri.parse(enterpriseUrl));

    if(enterpriseResponse.statusCode == 200){
      setState(() {
        enterprise = json.decode(enterpriseResponse.body);
      });
    }else{
      print("no existe empresita");
    }

    final Map<String, String> body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'documentType': documentType!,
      'area': area,
      'documentId': documentId,
      'enterpriseId': enterprise['id'].toString(),
    };

    print("ESTE SERÁ EL CUERPO");
    print(body);

     final response =
        await http.post(Uri.parse(apiUrl), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    print("NÚMERO RESPUESTA");
    print( response.statusCode);

    if( response.statusCode == 201){
      print("Trabajador creado");
    }else{
      print("Ups algo pasó");
    }


  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Trabajador'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el email';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedDocumentType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDocumentType = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Tipo de Documento'),
                items: <String>['DNI', 'otro']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
              ),
              TextFormField(
                controller: documentNumberController,
                decoration: InputDecoration(labelText: 'Número de Documento'),
                onChanged: (value) {
                  setState(() {
                    _documentNumber = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número de documento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: areaController,
                decoration: InputDecoration(labelText: 'Área'),
                onChanged: (value) {
                  setState(() {
                    _area = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el área';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí puedes realizar la acción de guardar el nuevo trabajador
                    // Por ejemplo, puedes enviar los datos a una API
                    // Una vez guardado, puedes navegar a otra pantalla o realizar alguna acción adicional
                    createWorker(_selectedDocumentType, firstNameController.text, lastNameController.text, emailController.text, documentNumberController.text, areaController.text);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


