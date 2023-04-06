import 'package:flutter/material.dart';
import 'package:todo_api/view/add_todo.dart';

class ItemCard extends StatelessWidget {
  final Map item;
  final int index;
  final Function(Map) navigateEditItemPage;
  final Function(String) delelteById;

  const ItemCard(
      {super.key,
      required this.item,
      required this.index,
      required this.navigateEditItemPage,
      required this.delelteById});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'update') {
              // open update page
              navigateEditItemPage(item);
            } else if (value == 'delete') {
              // open delete page
              delelteById(id);
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
      ),
    );
  }
}
