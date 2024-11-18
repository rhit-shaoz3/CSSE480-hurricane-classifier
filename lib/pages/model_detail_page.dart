import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_project/components/display_photo.dart';
import 'package:final_project/managers/photo_bucket_document_manager.dart';
import 'package:flutter/material.dart';


class ModelDetailPage extends StatefulWidget {
  final String documentId;
  final String modelName;
  final String imagePath;

  const ModelDetailPage({
    super.key, 
    required this.documentId, 
    required this.modelName,
    required this.imagePath,
  });

  @override
  State<ModelDetailPage> createState() => _ModelDetailPageState();
}

class _ModelDetailPageState extends State<ModelDetailPage> {
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
        // if (ModelDocumentManager.instance.authorUid.isNotEmpty) {
        //   userDataSubscription =
        //       UserDataDocumentManager.instance.startListening(
        //     documentId: ModelDocumentManager.instance.authorUid,
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
    // print(
    //     "Display the author information for: ${UserDataDocumentManager.instance.displayName}");
    // print(
    //     "and display the picture at ${UserDataDocumentManager.instance.imageUrl}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hurricane Classifier"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: Column(
                  children: [
                    Text(
                      PhotoBucketDocumentManager.instance.name,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 20.0,),
                    Text(
                      "Category: ${PhotoBucketDocumentManager.instance.category}",
                      style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 30.0,),
                    FutureBuilder(
                      future: Future.delayed(const Duration(milliseconds: 300)), // Delay for 1 second
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
                  ],
                ),
              ),
              //"TODO: Make FLASK/PYTHON API to run model in backend and then fetch result via http request"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: Column(
                  children: [
                    Text(
                      "${widget.modelName} Prediction",
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 50.0,),
                    // const Text(
                    //   "Baseline: TBD",
                    //   style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    // ),
                    // const SizedBox(height: 20.0,),
                    // const Text(
                    //   "Optimized: TBD",
                    //   style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    // ),
                    FutureBuilder<Map<String, dynamic>> (
                      future: getBaselinePrediction(),  // Call the function that returns a Future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();  // Show a loading spinner
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');  // Show error message
                        } else if (snapshot.hasData) {
                          // Display the prediction result when data is available
                          var prediction = snapshot.data!;
                          String cat = toCategory(prediction['prediction']);
                          return Text(
                            "Baseline: $cat",
                            style: const TextStyle(fontSize: 20),
                          );
                        } else {
                          return const Text("No data found.");
                        }
                      },
                    ),
                    const SizedBox(height: 20.0,),
                    FutureBuilder<Map<String, dynamic>> (
                      future: getOptimizedPrediction(),  // Call the function that returns a Future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();  // Show a loading spinner
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');  // Show error message
                        } else if (snapshot.hasData) {
                          // Display the prediction result when data is available
                          var prediction = snapshot.data!;
                          String cat = toCategory(prediction['prediction']);
                          return Text(
                            "Optimzed: $cat",
                            style: const TextStyle(fontSize: 20),
                          );
                        } else {
                          return const Text("No data found.");
                        }
                      },
                    ),
                  ],
                ),
              ),
          ], 
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getOptimizedPrediction() async {
    final url = Uri.parse("https://428d-137-112-200-70.ngrok-free.app/predict");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "model_name": widget.modelName,
          "image_path": widget.imagePath,
        }),
      );

      if (response.statusCode == 200) {
        final prediction = jsonDecode(response.body);
        return prediction;  // Return the result as a map
      } else {
        throw Exception("Failed to get prediction: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> getBaselinePrediction() async {
    final url = Uri.parse("https://428d-137-112-200-70.ngrok-free.app/predictbase");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "model_name": widget.modelName,
          "image_path": widget.imagePath,
        }),
      );

      if (response.statusCode == 200) {
        final prediction = jsonDecode(response.body);
        return prediction;  // Return the result as a map
      } else {
        throw Exception("Failed to get prediction: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  String toCategory(int label) {
    if (label == 0) {
      return 'C1';
    } else if (label == 1) {
      return 'C2';
    } else if (label == 2) {
      return 'C3';
    } else if (label == 3) {
      return 'C4';
    } else if (label == 4) {
      return 'C5';
    } else if (label == 5) {
      return 'TD';
    } else if (label == 6) {
      return 'TS';
    } else {
      return 'NULL';
    }
  }

}