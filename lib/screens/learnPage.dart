import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class learnPage extends StatefulWidget {
  const learnPage({super.key});

  @override
  State<learnPage> createState() => _learnPageState();
}

class _learnPageState extends State<learnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('learn'),
    );
  }
}
