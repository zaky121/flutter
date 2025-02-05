import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/signup.dart';
import 'package:flutter_application_1/pages/structure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const FlutterSecureStorage storage = FlutterSecureStorage();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid input
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse("http://localhost:8000/api/auth/login");
      final response = await http.post(
        url,
        body: jsonEncode({'email': _email, 'password': _password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: "token", value: data['token']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (builder) => const Structure()),
        );
      } else {
        final errorData = jsonDecode(response.body);
        _showErrorDialog(errorData['message'] ?? "An error occurred.");
      }
    } catch (e) {
      _showErrorDialog("Failed to connect to the server.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Login Failed"),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Ok"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add a gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 232, 232, 239), Color(0xFF76B947)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: const Color.fromRGBO(0, 0, 255, 0.5),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo or Icon
                      Icon(
                        Icons.lock,
                        size: 100,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      // Email Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email.";
                          }
                          final emailRegex = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                              r"[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (!emailRegex.hasMatch(value)) {
                            return "Please enter a valid email.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password.";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters.";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _login, // Prevent multiple clicks
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 31, 22, 162),
                          ),
                          child: const Text(
                            "LOGIN", // Always shows "LOGIN"
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Signup Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => const Signup()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
