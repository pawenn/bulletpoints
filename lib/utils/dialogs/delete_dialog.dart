import 'package:bulletpoints/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are you sure you want to delete this note?",
    optionsBuilder: () => {'No': false, 'Yes': true},
  ).then(
    (value) => value ?? false,
  );
}
