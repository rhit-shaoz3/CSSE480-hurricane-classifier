// import 'dart:async';
// import 'package:final_project/components/display_card.dart';
// import 'package:final_project/components/display_photo.dart';
// import 'package:final_project/managers/auth_manager.dart';
// import 'package:final_project/managers/photo_bucket_document_manager.dart';
// import 'package:final_project/managers/user_data_document_manager.dart';
// import 'package:final_project/models/photo.dart';
import 'package:flutter/material.dart';


class ModelOverviewPage extends StatefulWidget {
  // final MovieQuote movieQuote;
  // final String documentId;
  // final String modelName;
  const ModelOverviewPage({super.key,});

  @override
  State<ModelOverviewPage> createState() => _ModelOverviewPageState();
}

class _ModelOverviewPageState extends State<ModelOverviewPage> {
  // StreamSubscription? hurricaneSubscription;
  // StreamSubscription? userDataSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // nameTextEditingController.dispose();
    // categoryTextEditingController.dispose();
    // PhotoBucketDocumentManager.instance.stopListening(hurricaneSubscription);
    // UserDataDocumentManager.instance.stopListening(userDataSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hurricane Classifier"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: const Column(
                    children: [
                      Text(
                        "CNN Model Performance Overview",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        "VGG-16 baseline: 52.13%",
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        "VGG-16 optimized: 53.66%",
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        "ResNet baseline: 59.97%",
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        "ResNet optimized: 70.38%",
                        style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                      ),
                    ],
                      //"TODO: swap the image into a table/image of our model performance"
                      // FutureBuilder(
                      //   future: Future.delayed(const Duration(milliseconds: 300)), // Delay for 1 second
                      //   builder: (context, snapshot) {
                      //     // Check if the future is complete
                      //     if (snapshot.connectionState == ConnectionState.done
                      //         && PhotoBucketDocumentManager.instance.url.isNotEmpty) {
                      //       // Display the photo after 1 second
                      //       return DisplayPhoto(
                      //         displayImage: PhotoBucketDocumentManager.instance.url,
                      //       );
                      //     } else {
                      //       // You can return a placeholder while waiting
                      //       return const CircularProgressIndicator();
                      //     }
                      //   },
                      // ),
                  ),
                ),
        ),
    );
  }

}