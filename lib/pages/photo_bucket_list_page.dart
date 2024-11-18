// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/components/list_page_drawer.dart';
import 'package:final_project/components/photo_bucket_form_dialog.dart';
import 'package:final_project/components/photo_bucket_row.dart';
import 'package:final_project/managers/auth_manager.dart';
import 'package:final_project/managers/photo_bucket_collection_manager.dart';
import 'package:final_project/managers/user_data_document_manager.dart';
import 'package:final_project/models/photo.dart';
import 'package:final_project/pages/login_front_page.dart';
import 'package:final_project/pages/photo_bucket_detail_page.dart';
// import 'package:final_project/pages/profile_page.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class PhotoBucketListPage extends StatefulWidget {
  const PhotoBucketListPage({super.key});

  @override
  State<PhotoBucketListPage> createState() => _PhotoBucketListPageState();
}

class _PhotoBucketListPageState extends State<PhotoBucketListPage> {
  // List<MovieQuote> movieQuotes = [];
  // var movieQuotes = <MovieQuote>[];
  final nameTextEditingController = TextEditingController();
  final categoryTextEditingController = TextEditingController();
  final urlTextEditingController = TextEditingController();
  // StreamSubscription? PhotoSubscription;
  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;
  // bool _isShowingAllPhotos = true;


  @override
  void initState() {
    super.initState();
    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      UserDataDocumentManager.instance.maybeAddNewUser();
      setState(() {});
    });
    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      setState(() {});
    });
    // FirebaseFirestore.instance
    // .collection("MovieQuotes")
    // .snapshots()
    // .listen((QuerySnapshot querySnapshot) {
    //   for(final doc in querySnapshot.docs) {
    //     print(doc.id);
    //     print(doc.data());
    //   }
    // });
    // PhotoSubscription =
    //     PhotoBucketCollectionManager.instance.startListening(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    categoryTextEditingController.dispose();
    urlTextEditingController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey);
    AuthManager.instance.removeObserver(_logoutObserverKey);
    // PhotoBucketCollectionManager.instance
    //     .stopListening(PhotoSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[];
    if (!AuthManager.instance.isSignedin) {
      actions = [
        IconButton(
          tooltip: "Log in",
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginFrontPage(),
              ),
            );
            setState(() {});
          },
          icon: const Icon(Icons.login),
        ),
      ];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Hurricane classifier"),
        actions: actions,
      ),
      body: FirestoreListView(
        query: PhotoBucketCollectionManager.instance.allPhotosQuery,
        itemBuilder: (context, snapshot) {
          final Photo pt = snapshot.data();
          return PhotoBucketRow(
            pt: pt,
            onClick: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PhotoBucketDetailPage(documentId: pt.documentId!),
                ),
              );
            },
          );
        },
      ),
      drawer: AuthManager.instance.isSignedin
        ? const ListPageDrawer()
        : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showCreatePhotoDialog();
          if (AuthManager.instance.isSignedin) {
            showCreatePhotoDialog();
          } else {
            showLoginRequestDialog();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void showLoginRequestDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Login Required"),
            content: const Text(
                "You must be signed in to add a hurricane.  Would you like to sign in now?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.white),),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginFrontPage(),
                    ),
                  );
                  setState(() {});
                },
                child: const Text("Go to Sign in Page", style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        });
  }

  void showCreatePhotoDialog() {
    nameTextEditingController.text = "";
    categoryTextEditingController.text = "";
    // urlTextEditingController.text = "";
    showDialog(
      context: context,
      builder: (context) => PhotoBucketFormDialog(
        nameTextEditingController: nameTextEditingController,
        categoryTextEditingController: categoryTextEditingController,
        // // urlTextEditingController: urlTextEditingController,
        // positiveAction: () {
        //   // if (urlTextEditingController.text == "") {
        //   //   urlTextEditingController.text = "assets/images/sample_hurricane.png";
        //   // }
          // PhotoBucketCollectionManager.instance.add(
          //   name: nameTextEditingController.text,
          //   category: categoryTextEditingController.text, 
          //   url: urlTextEditingController.text,
          // );
        // },
      ),
    );
  }
}