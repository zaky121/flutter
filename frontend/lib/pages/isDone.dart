import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:http/http.dart' as http;

class IsDone extends StatefulWidget {
  final String id;
  final bool isDone;
  final VoidCallback fetchTasks;

  const IsDone(
      {super.key,
      required this.id,
      required this.fetchTasks,
      required this.isDone});

  @override
  State<IsDone> createState() => _IsDoneState();
}

class _IsDoneState extends State<IsDone> {
  void isDone(bool done, String id) async {
    var token = await Utils.token;
    final url = Uri.parse("http://localhost:8000/api/tasks/done/$id");
    final res = await http.put(
      url,
      body: jsonEncode({'isDone': done}),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    if (res.statusCode == 200) {
      widget.fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        isDone(!widget.isDone, widget.id);
      },
      icon:
          Icon(widget.isDone ? Icons.check_box : Icons.check_box_outline_blank),
    );
  }
}
