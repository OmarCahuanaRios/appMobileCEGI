import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_receptions/homeEnteprise.dart';
import 'package:mobile_receptions/visitList.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(String email, String password, BuildContext context) async {
    const apiUrl = 'http://192.168.1.36:8090/auth/authenticate';
    print("entra esta ");
     final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    print("cuerpito");
    print(body);

    final response =
        await http.post(Uri.parse(apiUrl), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    Map<String, dynamic> respuesta = json.decode(response.body);
    print("RESPUESTA");
    print(response.statusCode);

     if (response.statusCode == 200) {

       final responseData = json.decode(response.body);
       String role = responseData['role'];
        String token = responseData['token'];
        String enterpriseName = responseData['enterpriseName'];

        if( role == "ROLE_ENTERPRISE"){
          Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeEnterpriseScreen(enterpriseName: enterpriseName)),
                    );
        }

        if ( role == "ROLE_ADMIN"){
          Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisitListScreen(enterpriseName: enterpriseName,role: role)),
                    );
        }

  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Image.asset(
              'images/golf.jpg', // Ruta de la imagen
              height: 150.0,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
               final String usuario = emailController.text;
               final String contrasenia = passwordController.text;
               login(usuario, contrasenia, context);
              },
              child: Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

