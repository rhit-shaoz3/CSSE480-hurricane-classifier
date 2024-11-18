import 'package:flutter/material.dart';

class PhotoBucketEditDialog extends StatelessWidget {
  final TextEditingController nameTextEditingController;
  final TextEditingController categoryTextEditingController;
  final void Function() positiveAction;

  const PhotoBucketEditDialog({
    super.key,
    required this.nameTextEditingController,
    required this.categoryTextEditingController,
    required this.positiveAction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Name"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameTextEditingController,
            decoration: const InputDecoration(
              labelText: "Name",
              border: UnderlineInputBorder(),
            ),
          ),
          TextField(
            controller: categoryTextEditingController,
            decoration: const InputDecoration(
              labelText: "Category",
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            positiveAction();
            Navigator.pop(context);
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}