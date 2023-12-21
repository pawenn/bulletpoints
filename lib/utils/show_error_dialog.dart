
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String errorMessage){
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            }, 
            child: const Text('Ok')
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
  
}