import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api/view/add_todo.dart';
import 'package:http/http.dart' as http;

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item['title']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateScreen(context, AddTodo());
        },
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> fetchData() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    if (respone.statusCode == 200) {
      final json = jsonDecode(respone.body);
      final result = json['items'] as List;
      // items.map((e) {
      setState(() {
        items = result;
      });
      // });
    }
    // print(respone.body);
  }

  void navigateScreen(BuildContext context, dynamic page) {
    final route = MaterialPageRoute(builder: (context) => page);
    Navigator.push(context, route);
  }
}
