import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key, this.segments}) : super(key: key);

  final List<String> segments;

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
        child: Text(widget.segments[0]),
      ),
    );
  }
}
