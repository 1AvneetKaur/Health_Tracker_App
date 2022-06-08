import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String age = "";
  String bp = "";
  late DocumentReference _documentReference;
  late SharedPreferences _preferences;

  _createDocumentReference() async {
    _preferences = await SharedPreferences.getInstance();
    String? docId = _preferences.getString("doc_id");
    if (docId == null) {
      _documentReference =
          FirebaseFirestore.instance.collection("My Tracker").doc();
      _preferences.setString("doc_id", _documentReference.id);
    } else {
      _documentReference =
          FirebaseFirestore.instance.collection("My Tracker").doc(docId);
    }
  }

  @override
  void initState() {
    super.initState();
    _createDocumentReference();
  }

  createTracker() async {
    Map<String, String> bpData = {"Age": age, "BP": bp};
    await _documentReference
        .collection("BP")
        .doc()
        .set(bpData, SetOptions(merge: true))
        .whenComplete(
      () {
        log("Data Stored!");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data Stored!")));
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker App'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Add your today's health record here"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text('Today'),
                  content: SizedBox(
                      width: 400,
                      height: 200,
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration.collapsed(
                              hintText: 'add your age',
                            ),
                            onChanged: (String value) {
                              age = value;
                            },
                          ),
                          const Text(''),
                          TextField(
                            decoration: const InputDecoration.collapsed(
                              hintText: 'add your BP',
                            ),
                            onChanged: (String value) {
                              bp = value;
                            },
                          )
                        ],
                      )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: createTracker,
                      child: const Text('Add'),
                    )
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add,
              color: Colors
                  .white)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
