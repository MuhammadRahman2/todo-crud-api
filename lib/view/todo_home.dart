import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api/utils/utils.dart';
import 'package:todo_api/view/add_todo.dart';
import 'package:http/http.dart' as http;

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List items = [];
  bool isLoading = false;
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
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index] as Map;
            final id = item['_id'];
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'update') {
                    // open update page
                    navigateScreen(context, AddTodo(item: item));
                  } else if (value == 'delete') {
                    // open delete page
                    deleteData(id);
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'update',
                      child: Text('update'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('delete'),
                    ),
                  ];
                },
              ),
            );
          },
        ),
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
    } else {
      Utils.showMassageError(context, 'Creating is failed');
    }
    // print(respone.body);
  }

  Future<void> deleteData(String id) async {
    // delete item
    // https://api.nstack.in/v1/todos/642a891e26d47c915250ad7e
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final respone = await http.delete(uri);
    if (respone.statusCode == 200) {
      Utils.showMassage(context, 'Delete Success');

      // delete item form list
      final filter = items.where((e) => e['_id'] != id).toList();
      setState(() {
        items = filter;
      });
    } else {
      Utils.showMassageError(context, 'delete Failed');
    }
    isLoading = false;
  }

  Future<void> navigateScreen(BuildContext context, dynamic page) async {
    final route = MaterialPageRoute(builder: (context) => page);
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }
}
