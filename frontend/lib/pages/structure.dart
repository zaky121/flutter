import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/addTask.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/tasks.dart';

class Structure extends StatefulWidget {
  const Structure({super.key});

  @override
  State<Structure> createState() => _StructureState();
}

class _StructureState extends State<Structure> {
  int _currentIndex = 2;
  var screens = [const Home(), const Tasks(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const AddTask()));
        },
        child: const Text("+"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile",
          ),
        ],
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
