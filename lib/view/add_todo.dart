import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/services/item_services.dart';
import 'package:todo_api/utils/utils.dart';

class AddTodo extends StatefulWidget {
  final Map? item;

  AddTodo({super.key, this.item});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  bool isEdit = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      isEdit = true;
      titleController.text = item['title'];
      descriptionController.text = item['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'update data' : 'add data'),
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
                    isEdit
                        ? PutData().then((value) => Navigator.pop(context))
                        : postData(context).then((value) {
                            titleController.clear();
                            descriptionController.clear();
                            Navigator.pop(context);
                          });
                  },
                  child: Text(isEdit ? 'Update' : 'Add Data')),
            )
          ],
        ),
      ),
    );
  }

  Future<void> PutData() async {
    final item = widget.item;
    if (item == null) {
      print('you can not call update with out item');
      return;
    }
    final id = item['_id'];
    var title = titleController.text;
    var description = descriptionController.text;
    final body = {
      'title': title,
      'description': description,
      "is_completed": false
    };
    final isSuccess = await ItemServices.updateById(id, body);
    if (isSuccess) {
      Utils.showMassage(context, 'update is Success');
    } else {
      Utils.showMassageError(context, 'update Failed');
    }
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
    final isSuccess =await ItemServices.addData(body);
    if (isSuccess) {
      // print('S');
      Utils.showMassage(context, 'Create is Success');
    } else {
      Utils.showMassageError(context, 'Creation Failed');
    }
    // show message success or fail
  }
}
