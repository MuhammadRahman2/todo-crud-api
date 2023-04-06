import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/utils/utils.dart';

// all item api services will be here
class ItemServices {

  static Future<List?> fetchItemData(BuildContext context) async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    if (respone.statusCode == 200) {
      final json = jsonDecode(respone.body);
      final result = json['items'] as List;
      return result;
    } else {
      Utils.showMassageError(context, 'Creating is failed');
      return null;
    }
  }

  static Future<bool> addData(Map body) async {
    const baseUrl = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(baseUrl);
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    return response.statusCode == 201;
  }

  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final respone = await http.delete(uri);
    return respone.statusCode == 200;
  }

  static Future<bool> updateById(String id, Map body) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return response.statusCode == 200;
  }
}
