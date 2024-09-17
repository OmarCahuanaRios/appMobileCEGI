import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CreateVisitScreen extends StatefulWidget {
  final String enterpriseName;
  CreateVisitScreen({required this.enterpriseName}){}
  @override
  _CreateVisitScreenState createState() => _CreateVisitScreenState();
}

class _CreateVisitScreenState extends State<CreateVisitScreen> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _documentTypeController = TextEditingController();
  TextEditingController _documentNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _documentTypeValue;
  Map<String, dynamic> enterprise = {};
  Map<String, dynamic> visitant = {};

  Future<void> createVisit(String date, String time, String firstName, String lastName, String? documentType, String documentNumber, String email) async{
    String enterpriseUrl = 'http://192.168.1.36:8090/enterprise/name/${widget.enterpriseName}';
    String visitantUrl = 'http://192.168.1.36:8090/visitant';
    String visitUrl = 'http://192.168.1.36:8090/visit';

    final enterpriseResponse = await http.get(Uri.parse(enterpriseUrl));

    print("ESTADO EMPRESA");
    print(enterpriseResponse.statusCode);
    
    setState(() {
      enterprise = json.decode(enterpriseResponse.body);
    });


    final Map<String, String> visitantBody = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'documentType': documentType!,
      'documentId': documentNumber,
      'enterpriseId': enterprise['id'].toString(),
    };

    
    final visitantResponse =
        await http.post(Uri.parse(visitantUrl), body: jsonEncode(visitantBody), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

      print("ESTADO VISITANTE");
    print(visitantResponse.statusCode);

    visitant = json.decode(visitantResponse.body);


    final Map<String, dynamic> visitBody = {
      'appointmentDate': date,
      'appointmentHour': time,
      'status': "Aceptado",
      'visitType': true,
      'visitantId': visitant['id'].toString(),
    };

     final visitResponse =
        await http.post(Uri.parse(visitUrl), body: jsonEncode(visitBody), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

      print("ESTADO vISITA");
    print(visitResponse.statusCode);
    Navigator.pop(context);
    
  }

  Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    }, 
  );
  if (pickedTime != null) {
    setState(() {
      _timeController.text = pickedTime.format(context);
    });
  }
}


  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _documentTypeController.dispose();
    _documentNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Visita'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Cita',
                  prefixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 10.0),
             TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Hora de Cita',
                      prefixIcon: IconButton(
                        icon: Icon(Icons.access_time),
                        onPressed: () {
                          _selectTime(context); 
                        },
                      ),
                    ),
                  ),
              SizedBox(height: 10.0),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Nombres',prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Apellidos',prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                          value: _documentTypeValue,
                          onChanged: (newValue) {
                            setState(() {
                              _documentTypeValue = newValue!;
                            });
                          },
                          items: <String>['DNI', 'Pasaporte']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Tipo de Documento',
                            prefixIcon: Icon(Icons.assignment_ind),
                          ),
                        ),

              SizedBox(height: 10.0),
              TextField(
                controller: _documentNumberController,
                decoration: InputDecoration(labelText: 'Número de Documento',prefixIcon: Icon(Icons.format_list_numbered)),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email',prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String date = _dateController.text;
                  String time = _timeController.text;
                  String firstName = _firstNameController.text;
                  String lastName = _lastNameController.text;
                  String documentNumber = _documentNumberController.text;
                  String email = _emailController.text;

                  createVisit(date, time, firstName, lastName, _documentTypeValue, documentNumber, email);
                },
                child: Text('Guardar Visita'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }
}
