import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_api/services/item_services.dart';
import 'package:todo_api/utils/utils.dart';
import 'package:todo_api/view/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/widget/item_card.dart';

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
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text('No Todo Item'),
            ),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'];
                return ItemCard(
                  item: item, 
                  index: index, 
                  navigateEditItemPage: navigateEditScreen, 
                  delelteById:  deleteData,);
              },
            ),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateAddScreen();
        },
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> fetchData() async {
    final respone = await ItemServices.fetchItemData(context);
    if (respone != null) {
      setState(() {
        items = respone;
      });
    } else {
      Utils.showMassageError(context, 'Creating is failed');
    }
    setState(() {
      isLoading = false;
    });
    // print(respone.body);
  }

  Future<void> deleteData(String id) async {
    // delete item
    final isSucces = await ItemServices.deleteById(id);
    if (isSucces) {
      Utils.showMassage(context, 'Delete Success');

      // delete item form list
      final filter = items.where((e) => e['_id'] != id).toList();
      setState(() {
        items = filter;
      });
    } else {
      Utils.showMassageError(context, 'delete Failed');
    }
  }

  Future<void> navigateAddScreen() async {
    final route = MaterialPageRoute(builder: (context) => AddTodo());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateEditScreen(Map mapItem) async {
    final route = MaterialPageRoute(builder: (context) => AddTodo(item: mapItem));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }
}
