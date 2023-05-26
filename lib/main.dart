import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  String glbReferenceUrl = "";
  late Directory appDocDir;
  @override
  void initState() {
    getDownloadUrl();
    super.initState();
  }

  void getDownloadUrl() async {
    glbReferenceUrl = await FirebaseStorage.instance
        .refFromURL("gs://oasis-2022.appspot.com/brain.glb")
        .getDownloadURL();
    print(glbReferenceUrl);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: isLoading,
            builder: (context, value, child) {
              if (value) {
                return const CircularProgressIndicator();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    SizedBox(
                        height: 500,
                        width: 500,
                        child: ModelViewer(
                          src: glbReferenceUrl,
                          loading: Loading.lazy,
                          autoRotate: true,
                          rotationPerSecond: "30deg",
                          disablePan: true,
                          disableZoom: true,
                        ))
                  ],
                );
              }
            }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
