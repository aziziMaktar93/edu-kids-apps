import 'package:flutter/material.dart';

void main() {
  runApp(const EduKidsPlaceholder());
}

class EduKidsPlaceholder extends StatelessWidget {
  const EduKidsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('EduKids')),
      ),
    );
  }
}
