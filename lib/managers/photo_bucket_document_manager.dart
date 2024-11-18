import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/photo.dart';
// import 'package:flutter/foundation.dart';


class PhotoBucketDocumentManager {
  Photo? latestPhoto;
  final CollectionReference _ref;

  static final PhotoBucketDocumentManager instance =
      PhotoBucketDocumentManager._privateConstructor();

  PhotoBucketDocumentManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kPhotoBucketCollectionPath);

  StreamSubscription startListening({
    required String documentId,
    required Function observer,
  }) =>
      _ref.doc(documentId).snapshots().listen(
          (DocumentSnapshot documentSnapshot) {
        latestPhoto = Photo.from(documentSnapshot);
        observer();
      }, onError: (error) {
        print("Error listening for Photo $error");
      });

  void stopListening(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  Future<void> delete() async {
    return _ref.doc(latestPhoto!.documentId!).delete();
    // try {
    //   await Future.delayed(const Duration(seconds: 1));
    //   await _ref.doc(latestPhoto!.documentId).delete();
    //   print('Document deleted successfully');
    // } catch (e) {
    //   print('Error deleting document: $e');
    // }
  }

  // Comment out add, since update will have similarities.
  Future<void> update({
    required String name,
    required String category,
  }) {
    return _ref.doc(latestPhoto!.documentId!).update({
      kPhotoBucketName: name,
      kPhotoBucketCategory: category,
      // kPhotoBucketURL: url,
      // kPhotoBucketLastTouched: Timestamp.now(),
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void restore(Photo ptToRestore) {
    _ref.doc(ptToRestore.documentId!).set({
      kPhotoBucketName: ptToRestore.name,
      kPhotoBucketCategory: ptToRestore.category,
      kPhotoBucketURL: ptToRestore.url,
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  void clearLatest() {
    latestPhoto = null;
  }

  String get name => latestPhoto?.name ?? "";
  String get url => latestPhoto?.url ?? "";
  String get category => latestPhoto?.category ?? "";
}