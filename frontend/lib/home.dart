import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
        ),
        body: Center(
          child: MaterialButton(
              child: Text("This is button"),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              }),
        ));
  }
}
