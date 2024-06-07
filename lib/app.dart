import 'package:flutter/material.dart';
import 'package:web_browser/screen/home_screen.dart';

class WebBrowser extends StatelessWidget {
  const WebBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
