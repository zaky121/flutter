import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:http/http.dart' as http;

class DeleteTask extends StatefulWidget {
  final String id;
  final VoidCallback fetchTasks;

  const DeleteTask({super.key, required this.id,required this.fetchTasks});

  @override
  State<DeleteTask> createState() => _DeleteTaskState();
}

class _DeleteTaskState extends State<DeleteTask> {
  void deleteTask(String id) async {
    var token = await Utils.token;
    final url = Uri.parse("http://localhost:8000/api/tasks/delete/$id");
    final res  = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if(res.statusCode == 200){
      Navigator.pop(context);
      widget.fetchTasks();
    }
  }

  void deleteTaskDialog() async {
    await showDialog(
      context: context,
      builder: (builder) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              deleteTask(widget.id);
            },
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: deleteTaskDialog,
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}
