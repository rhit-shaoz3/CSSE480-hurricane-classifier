import 'dart:async';
import 'package:final_project/components/display_photo.dart';
import 'package:final_project/components/photo_bucket_edit_dialog.dart';
import 'package:final_project/managers/auth_manager.dart';
import 'package:final_project/managers/photo_bucket_document_manager.dart';
import 'package:final_project/models/photo.dart';
import 'package:final_project/pages/model_detail_page.dart';
import 'package:flutter/material.dart';


class PhotoBucketDetailPage extends StatefulWidget {
  // final MovieQuote movieQuote;
  final String documentId;
  const PhotoBucketDetailPage({super.key, required this.documentId,});

  @override
  State<PhotoBucketDetailPage> createState() => _PhotoBucketDetailPageState();
}

class _PhotoBucketDetailPageState extends State<PhotoBucketDetailPage> {
  final nameTextEditingController = TextEditingController();
  final categoryTextEditingController = TextEditingController();
  StreamSubscription? hurricaneSubscription;
  // StreamSubscription? userDataSubscription;

  @override
  void initState() {
    super.initState();
    hurricaneSubscription = PhotoBucketDocumentManager.instance.startListening(
      documentId: widget.documentId,
      observer: () {
        // if (PhotoBucketDocumentManager.instance.authorUid.isNotEmpty) {
        //   userDataSubscription =
        //       UserDataDocumentManager.instance.startListening(
        //     documentId: PhotoBucketDocumentManager.instance.authorUid,
        //     observer: () {
        //       setState(() {});
        //     },
        //   );
        // }
        // print("Received the document");
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    categoryTextEditingController.dispose();
    PhotoBucketDocumentManager.instance.stopListening(hurricaneSubscription);
    // UserDataDocumentManager.instance.stopListening(userDataSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    if (PhotoBucketDocumentManager.instance.latestPhoto != null &&
        AuthManager.instance.uid.isNotEmpty) {
      actions = <Widget>[
        IconButton(
          onPressed: () {
            showEditPhotoDialog();
          },
          tooltip: "Edit",
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            // print("You pressed the delete button");
            Photo deletedPt =
                PhotoBucketDocumentManager.instance.latestPhoto!;
            PhotoBucketDocumentManager.instance.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Photo deleted"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    PhotoBucketDocumentManager.instance.restore(deletedPt);
                  },
                ),
              ),
            );

            Navigator.of(context).pop();
          },
          tooltip: "Delete",
          icon: const Icon(Icons.delete),
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hurricane Classifier"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: actions,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    PhotoBucketDocumentManager.instance.name,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                  ),
                  Text(
                    "Category: ${PhotoBucketDocumentManager.instance.category}",
                    style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 500)), // Delay for 1 second
              builder: (context, snapshot) {
                // Check if the future is complete
                if (snapshot.connectionState == ConnectionState.done
                    && PhotoBucketDocumentManager.instance.url.isNotEmpty) {
                  // Display the photo after 1 second
                  return DisplayPhoto(
                    displayImage: PhotoBucketDocumentManager.instance.url,
                  );
                } else {
                  // You can return a placeholder while waiting
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.indigoAccent[200]),
                minimumSize: const WidgetStatePropertyAll(Size(256, 64)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ModelDetailPage(
                          documentId: widget.documentId, 
                          modelName: "VGG16", 
                          imagePath: PhotoBucketDocumentManager.instance.url,
                        ),
                  ),
                );
              },
              child: const Text(
                "Try on VGG-16",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.teal[600]),
                minimumSize: const WidgetStatePropertyAll(Size(256, 64)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ModelDetailPage(
                          documentId: widget.documentId, 
                          modelName: "ResNet", 
                          imagePath: PhotoBucketDocumentManager.instance.url,
                        ),
                  ),
                );
              },
              child: const Text(
                "Try on ResNet",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            const Spacer(),
          ], 
        ),
      )
    );
  }

  void showEditPhotoDialog() {
    nameTextEditingController.text = PhotoBucketDocumentManager.instance.name;
    categoryTextEditingController.text = PhotoBucketDocumentManager.instance.category;
    showDialog(
      context: context,
      builder: (context) => PhotoBucketEditDialog(
        nameTextEditingController: nameTextEditingController,
        categoryTextEditingController: categoryTextEditingController,
        positiveAction: () {
          // setState(() {
          //   widget.movieQuote.quote = quoteTextEditingController.text;
          //   widget.movieQuote.movie = movieTextEditingController.text;
          // });
          PhotoBucketDocumentManager.instance.update(
            name: nameTextEditingController.text,
            category: categoryTextEditingController.text,
            // url: urlTextEditingController.text,
          );
        },
      ),
    );
  }
}