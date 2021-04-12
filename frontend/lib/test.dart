import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key, this.match}) : super(key: key);

  final String match;

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test page"),
      ),
      body: Center(
        child: Text(widget.match),
      ),
    );
  }
}
