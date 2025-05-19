import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
// import 'package:flutter_application_1/screens/news_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'News App', home: HomeScreen());
  }
}
