import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
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

  createTracker() {
    DocumentReference documentReference = FirebaseFirestore.instance.collection("My Tracker").doc("bp");
    Map<String, String> userList = {"Age": age, "BP": bp};
    documentReference.set(userList, SetOptions(merge: true)).whenComplete(() => print("Data Stored!"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Tracker App'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Add your today's health record here")],
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
                      title: Text('Today'),
                      content: Container(
                          width: 400,
                          height: 200,
                          child: Column(
                            children: [
                              TextField(
                                decoration: new InputDecoration.collapsed(
                                    hintText: 'add your age'),
                                onChanged: (String value) {
                                  age = value;
                                },
                              ),
                              Text(''),
                              TextField(
                                decoration: new InputDecoration.collapsed(
                                    hintText: 'add your BP'),
                                onChanged: (String value) {
                                  bp = value;
                                },
                              )
                            ],
                          )),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(() {
                              createTracker();
                            });
                          },
                          child: Text('Add'),
                        )
                      ]);
                });
          },
          child: Icon(Icons.add,
              color: Colors
                  .white)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
