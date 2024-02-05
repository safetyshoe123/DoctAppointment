import 'package:flutter/material.dart';

class SnackBarUtils {
  static void defualtSnackBar(
      String? message, BuildContext context, Color? color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final SnackBar snackBar = SnackBar(
      content: Text(message ?? ''),
      backgroundColor: color ?? const Color.fromARGB(255, 53, 52, 52),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
