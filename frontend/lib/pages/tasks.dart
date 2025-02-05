import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/Task.dart';
import 'package:flutter_application_1/pages/deleteTask.dart';
import 'package:flutter_application_1/pages/editTask.dart';
import 'package:flutter_application_1/pages/isDone.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:http/http.dart' as http;

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<Task> tasks = [];
  bool isLoading = true;

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      var token = await Utils.token;

      var res = await http.get(
        Uri.parse("http://localhost:8000/api/tasks"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (res.statusCode == 200) {
        var jsonTasks = json.decode(res.body);
        setState(() {
          tasks = jsonTasks.map<Task>((data) => Task.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch tasks");
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tasks: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    var blue = Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: blue.shade800,
        elevation: 10,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchTasks,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : tasks.isEmpty
              ? Center(
                  child: Text(
                    'No tasks available.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchTasks,
                  color: Colors.blue.shade800,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          title: Text(
                            tasks[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          subtitle: tasks[index].due != null
                              ? Text(
                                  'Due: ${tasks[index].due!.toLocal()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              : null,
                          leading: IsDone(
                            id: tasks[index].id,
                            fetchTasks: fetchTasks,
                            isDone: tasks[index].isDone,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => EditTask(
                                        id: tasks[index].id,
                                        initialTitle: tasks[index].title,
                                        initialDueDate: tasks[index].due,
                                        fetchTasks: fetchTasks,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              DeleteTask(
                                id: tasks[index].id,
                                fetchTasks: fetchTasks,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => EditTask(
                                  id: tasks[index].id,
                                  initialTitle: tasks[index].title,
                                  initialDueDate: tasks[index].due,
                                  fetchTasks: fetchTasks,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
