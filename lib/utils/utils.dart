import 'package:flutter/material.dart';

class Utils{
  
   static void showMassage(BuildContext context, String value) {
    final snacker = SnackBar(content: Text(value));
    ScaffoldMessenger.of(context).showSnackBar(snacker);
  }

  static void showMassageError(BuildContext context, String value) {
    final snacker = SnackBar(
      backgroundColor: Colors.red,
      content: Text(value,style: const TextStyle(color: Colors.white),));
    ScaffoldMessenger.of(context).showSnackBar(snacker,);
  }
}