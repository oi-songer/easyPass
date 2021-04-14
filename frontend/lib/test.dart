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
    dynamic args = ModalRoute.of(context).settings.arguments;
    var arg = args == null ? '' : args['arg'];
    return Scaffold(
      appBar: AppBar(
        title: Text("test page"),
      ),
      body: Center(
          child: Column(
        children: [
          Text(widget.segments[0]),
          TextButton(
            child: Text(arg + " Back"),
            onPressed: () {
              Navigator.of(context).pop("test_ret");
            },
          ),
        ],
      )),
    );
  }
}
