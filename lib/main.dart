import 'package:cat_vs_dog_detector/constants.dart';
import 'package:cat_vs_dog_detector/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat vs Dog Detector App',
      theme: ThemeData(
        scaffoldBackgroundColor: kPrimaryColor,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

