import 'package:final_project/managers/photo_bucket_collection_manager.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';

class PhotoBucketFormDialog extends StatefulWidget {
  final TextEditingController nameTextEditingController;
  final TextEditingController categoryTextEditingController;
  // final TextEditingController urlTextEditingController;
  // final void Function() positiveAction;

  const PhotoBucketFormDialog({
    super.key,
    required this.nameTextEditingController,
    required this.categoryTextEditingController,
    // required this.urlTextEditingController,
    // required this.positiveAction,
  });

  @override
  State<PhotoBucketFormDialog> createState() => _PhotoBucketFormDialogState();
}

  class _PhotoBucketFormDialogState extends State<PhotoBucketFormDialog> {
    String? _updatedImageUrl;

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      widget.nameTextEditingController.dispose();
      widget.categoryTextEditingController.dispose();
      // UserDataDocumentManager.instance.stopListening(userDataSubscription);
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return AlertDialog(
        title: const Text("Add a Hurricane"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.nameTextEditingController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: UnderlineInputBorder(),
              ),
            ),
            TextField(
              controller: widget.categoryTextEditingController,
              decoration: const InputDecoration(
                labelText: "Category",
                border: UnderlineInputBorder(),
              ),
            ),
            // TextField(
            //   controller: urlTextEditingController,
            //   decoration: const InputDecoration(
            //     labelText: "URL",
            //     border: UnderlineInputBorder(),
            //   ),
            // ),
            UploadButton(
                  extensions: const ["jpg", "png"],
                  mimeTypes: const ["image/jpeg", "image/png"],
                  onError: (error, state) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    ));
                  },
                  onUploadComplete: (ref) async {
                    _updatedImageUrl = await ref.getDownloadURL();
                    setState(() {});
                  },
                ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // New so must be better?
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _updatedImageUrl ??= "assets/images/sample_hurricane";
              PhotoBucketCollectionManager.instance.add(
                name: widget.nameTextEditingController.text,
                category: widget.categoryTextEditingController.text, 
                url: _updatedImageUrl!,
              );
              Navigator.pop(context);
            },
            child: const Text("Submit"),
          ),
        ],
      );
    }
}