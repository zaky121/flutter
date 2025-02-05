import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _email = "";
  String? _name = "";
  String _password = "";
  Future<void> _signup() async {
    if (_email == "" || _password == "") {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Required Fields"),
                content: const Text("Email and Password Fields are required"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Ok"))
                ],
              ));
    }

    var res = await http.post(
        Uri.parse("http://localhost:8000/api/auth/register"),
        body:
            jsonEncode({'name': _name, 'email': _email, 'password': _password}),
        headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 201) {
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => const Login()));
    } else {
      throw Exception("Try Again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.person),
                  hintText: "Enter Your Name"),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Enter Your Email"),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.key),
                  hintText: "Enter Your Password"),
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(onPressed: _signup, child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
