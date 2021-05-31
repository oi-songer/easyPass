import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';

class InfoArguments {
  InfoArguments({this.isNew = true});

  bool isNew;
}

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => new _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final contentController = TextEditingController();
  List<DropdownMenuItem>? items;
  bool? isNew;
  String? infoId;
  var selectedValue;
  InfoArguments? arguments;

  @override
  void initState() {
    super.initState();

    items = [
      DropdownMenuItem(child: Text("姓名"), value: 1),
      DropdownMenuItem(child: Text("性别"), value: 2),
    ];

    // arguments = ModalRoute.of(context)!.settings.arguments as InfoArguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
