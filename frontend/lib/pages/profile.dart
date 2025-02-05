import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/model/Profile.dart';

import 'package:flutter_application_1/pages/login.dart';

import 'package:flutter_application_1/utils.dart';

import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  late Profile profile;

  bool isLoading = true;

  Future<void> userData() async {
    try {
      final token = await Utils.token;

      final res = await http.get(
        Uri.parse("http://localhost:8000/api/auth"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        setState(() {
          profile = Profile.fromJson(data);

          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  @override
  void initState() {
    super.initState();

    userData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Picture

              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              // Profile Name

              Text(
                profile.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              // Profile Email

              Text(
                profile.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              // Logout Button

              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    await Utils.clearToken;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const Login(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Additional Information Card

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.blue),
                          title: const Text(
                            "Phone",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            profile.phone ?? "Not provided",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              const Icon(Icons.location_on, color: Colors.blue),
                          title: const Text(
                            "Address",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            profile.address ?? "Not provided",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
