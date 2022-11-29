import 'package:flutter/material.dart';
import 'package:sug/consts.dart';
import 'package:sug/views/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: WebConstants.appName,
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}