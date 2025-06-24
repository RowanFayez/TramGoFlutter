import 'package:flutter/material.dart';
import 'screens/navigation_shell.dart';

void main() {
  runApp(AlexTramApp());
}

class AlexTramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TramGo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.tealAccent,
      ),
      home: NavigationShell(),
    );
  }
}
