import 'package:final_project/pages/photo_bucket_list_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final config = FirebaseUIStorageConfiguration(
    storage: FirebaseStorage.instance,
    uploadRoot: FirebaseStorage.instance.ref("Images"),
    namingPolicy:
        const UuidFileUploadNamingPolicy(), // optional, will generate a UUID for each uploaded file
  );
  await FirebaseUIStorage.configure(config);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // This sets a dark mode base
          primary: Colors.blueGrey[800],
          secondary: Colors.blueGrey,
          // background: Colors.black,
          surface: Colors.blueGrey[700],
        ),
        useMaterial3: true,
      ),
      home: const PhotoBucketListPage(),
    );
  }
}

