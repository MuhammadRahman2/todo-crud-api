import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatelessWidget {
  AddTodo({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              minLines: 3,
              maxLines: 4,
              
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'description',
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    postData(context).then((value) {
                      titleController.clear();
                      descriptionController.clear();
                    });
                  },
                  child: const Text('Add Data')),
            )
          ],
        ),
      ),
    );
  }

  Future<void> postData(
    BuildContext context,
  ) async {
    // get data from form
    var title = titleController.text;
    var description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      "is_completed": false
    };

    // add data to api
    const baseUrl = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(baseUrl);
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    if (response.statusCode == 201) {
      // print('S');
      showMassage(context, 'Create is Success');
    } else {
      showMassageError(context, 'Creation Failed');
    }
    // show message success or fail
  }

 void showMassage(BuildContext context, String value) {
    final snacker = SnackBar(content: Text(value));
    ScaffoldMessenger.of(context).showSnackBar(snacker);
  }

  void showMassageError(BuildContext context, String value) {
    final snacker = SnackBar(
      backgroundColor: Colors.red,
      content: Text(value,style: const TextStyle(color: Colors.white),));
    ScaffoldMessenger.of(context).showSnackBar(snacker,);
  }
}
