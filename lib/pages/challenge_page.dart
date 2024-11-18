import 'dart:async';
import 'package:final_project/components/display_photo.dart';
import 'package:final_project/managers/photo_bucket_document_manager.dart';
import 'package:final_project/pages/challenge_result_page.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class ChallengePage extends StatefulWidget {
  // final MovieQuote movieQuote;

  const ChallengePage({
    super.key, 
    // required this.level,
    // required this.score,
  });

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  StreamSubscription? hurricaneSubscription;
  int score = 0;
  int current = 0;
  List<String> images = [
    "assets/images/alex_ts.png",
    "assets/images/lester_c1.png",
    "assets/images/victor_td.png",
    "assets/images/winston_c5.png",
    "assets/images/winston_c2.png",
  ];
  List<String> labels = [
    "TS",
    "C1",
    "TD",
    "C5",
    "C2",
  ];
  List<List<String>> choices = [
    ["TD", "TS"],
    ["TS", "C1"],
    ["TD", "TS"],
    ["C4", "C5"],
    ["C2", "C3"],
  ];

  @override
  void initState() {
    super.initState();
    hurricaneSubscription = PhotoBucketDocumentManager.instance.startListening(
      documentId: "DfTZnJ2IMMFyAEI232IF",
      observer: () {
        setState(() {
          
        });
      },
    );
  }

  @override
  void dispose() {
    PhotoBucketDocumentManager.instance.stopListening(hurricaneSubscription);
    // UserDataDocumentManager.instance.stopListening(userDataSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Challenge"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: actions,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "Which Category?",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),
                  ),
                  // Text(
                  //   "Category: ${PhotoBucketDocumentManager.instance.category}",
                  //   style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 0)), // Delay for 1 second
              builder: (context, snapshot) {
                // Check if the future is complete
                if (snapshot.connectionState == ConnectionState.done
                    && PhotoBucketDocumentManager.instance.url.isNotEmpty) {
                  // Display the photo after 1 second
                  return DisplayPhoto(
                    displayImage: images[current],
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
                // minimumSize: WidgetStatePropertyAll(width),
              ),
              onPressed: () {
                if(choices[current][0] == labels[current]) {
                  score++;
                }
                if (current == 4) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChallengeResultPage(score: score,),
                    ),
                  );
                  setState(() {
                    current = 0;
                  });
                } else {
                  setState(() {current++;});
                }
              },
              child: Text(
                choices[current][0],
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.teal[600]),
                // minimumSize: const WidgetStatePropertyAll(Size(256, 64)),
              ),
              onPressed: () {
                if(choices[current][1] == labels[current]) {
                  score++;
                }
                if (current == 4) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChallengeResultPage(score: score,),
                    ),
                  );
                } else {
                  setState(() {current++;});
                }
              },
              child: Text(
                choices[current][1],
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            const Spacer(),
          ], 
        ),
      )
    );
  }
}