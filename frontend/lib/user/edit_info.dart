import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';

class EditInfoPage extends StatefulWidget {
  EditInfoPage({this.segments});

  final List<String> segments;

  @override
  _EditInfoPageState createState() => new _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final contentController = TextEditingController();
  List<DropdownMenuItem> items;
  bool isNew;
  String infoId;
  var selectedValue;

  @override
  void initState() {
    super.initState();

    items = [
      DropdownMenuItem(child: Text("姓名"), value: 1),
      DropdownMenuItem(child: Text("性别"), value: 2),
    ];

    if (widget.segments.length > 0 && widget.segments[0] == 'new') {
      isNew = true;
    } else {
      infoId = widget.segments[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Text(
            "编辑",
            style: TitleTextStyle,
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(left: 30, right: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "模板：",
                      style: InfoCardLeftTextStyle,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "内容：",
                      style: InfoCardLeftTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton(
                      items: items,
                      onChanged: (value) {
                        selectedValue = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      hintText: " ",
                      restorationId: "content_text_field",
                      controller: contentController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Divider(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: new EdgeInsets.all(20),
                child: MyAlertButton(
                  child: Text("取消"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: new EdgeInsets.all(20),
                child: MyButton(
                  child: Text("保存"),
                  onTap: () {
                    // TODO save

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
