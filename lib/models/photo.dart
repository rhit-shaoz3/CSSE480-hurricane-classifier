import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/firestore_model_utils.dart';

const kPhotoBucketCollectionPath = "Hurricanes";
const kPhotoBucketName = "name";
const kPhotoBucketCategory = "category";
const kPhotoBucketURL = "url";

class Photo {
  String? documentId;
  String name;
  String category;
  String url;

  Photo({
    this.documentId,
    required this.name,
    required this.category,
    required this.url,
  });

  // Need for listening.
  Photo.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          name: FirestoreModelUtils.getStringField(doc, kPhotoBucketName),
          category: FirestoreModelUtils.getStringField(doc, kPhotoBucketCategory),
          url: FirestoreModelUtils.getStringField(doc, kPhotoBucketURL),
        );

  // The oppostie direction (needed MUCH later)
  Map<String, Object?> toJsonMap() => {
        kPhotoBucketName: name,
        kPhotoBucketCategory: category,
        kPhotoBucketURL: url,
      };

  @override
  String toString() {
    return "Name: $name  Category: $category  Image: $url";
  }
}