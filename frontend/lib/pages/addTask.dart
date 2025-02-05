import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:http/http.dart' as http;

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String _title = "";
  DateTime _dueDate = DateTime.now();
  bool _isLoading = false;

  void _pickDueDate() async {
    DateTime? datePick = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (datePick != null) {
      setState(() {
        _dueDate = datePick;
      });
    }
  }

  void updateTask() async {
    if (_title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var token = await Utils.token;
      final url = Uri.parse("http://localhost:8000/api/tasks/create");
      final res = await http.post(
        url,
        body: jsonEncode(
            {'title': _title, 'due': _dueDate.toString().split(' ')[0]}),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (res.statusCode == 201) {
        Navigator.pop(context);
      } else {
        throw Exception("Failed to create task");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Task",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 10,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.blue.shade800),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade800),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.blue.shade800,
                ),
                const SizedBox(width: 10),
                Text(
                  "Due Date: ${_dueDate.toString().split(' ')[0]}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDueDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Pick Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : updateTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
