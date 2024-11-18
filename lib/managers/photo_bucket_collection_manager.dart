import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:final_project/managers/auth_manager.dart';
import 'package:final_project/models/photo.dart';


class PhotoBucketCollectionManager {
  var latestPhoto = <Photo>[];
  final CollectionReference _ref;

  static final PhotoBucketCollectionManager instance =
      PhotoBucketCollectionManager._privateConstructor();

  PhotoBucketCollectionManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kPhotoBucketCollectionPath);

  // StreamSubscription startListening(Function observer) => _ref
  //         .orderBy(kPhotoBucketLastTouched, descending: true)
  //         .snapshots()
  //         .listen((QuerySnapshot querySnapshot) {
  //       latestPhoto =
  //           querySnapshot.docs.map((doc) => Photo.from(doc)).toList();
  //       observer();
  //     }, onError: (error) {
  //       print("Error listening for Photo $error");
  //     });

  // void stopListening(StreamSubscription? subscription) {
  //   subscription?.cancel();
  // }

 Future<void> add({
    required String name,
    required String category,
    required String url,
  }) {
    return _ref.add({
      kPhotoBucketName: name,
      kPhotoBucketCategory: category,
      kPhotoBucketURL: url,
    }).then((DocumentReference docRef) {
      print("The add is finished, the doc id was ${docRef.id}");
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  Query<Photo> get allPhotosQuery =>
      _ref.orderBy(kPhotoBucketName, descending: false).withConverter(
            fromFirestore: (documentSnapshot, _) =>
                Photo.from(documentSnapshot),
            toFirestore: (photo, _) => photo.toJsonMap(),
          );

  // Query<Photo> get onlyMyPhotosQuery => allPhotosQuery
  //     .where(kPhotoBucketAuthorUid, isEqualTo: AuthManager.instance.uid);
}