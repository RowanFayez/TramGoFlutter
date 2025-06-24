import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("القائمة")),
      body: Center(
        child: Text(" إعدادات، مساعدة، عن التطبيق",
            style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
