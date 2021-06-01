import 'package:easy_pass/model/info.dart';
import 'package:easy_pass/model/template.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
import 'package:useful_widgets/useful_widgets.dart';

class InfoArguments {
  InfoArguments({this.info, this.isNew = true});

  bool isNew;
  Info? info;
}

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => new _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final contentController = TextEditingController();
  List<DropdownMenuItem>? items;
  bool isNew = true;
  Info? info;
  var selectedValue;
  InfoArguments? arguments;

  // TODO 获取accounts(info_auths)

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as InfoArguments;
    isNew = args.isNew;
    info = args.info;

    return Scaffold(
      body: Column(
        children: [
          Text(
            "信息",
            style: TitleTextStyle,
          ),
          Padding(
            padding: new EdgeInsets.all(10),
            child: Expanded(
              child: InfoDetailCard(
                isNew: isNew,
                info: info,
              ),
            ),
          ),
          // TODO add accounts here
        ],
      ),
    );
  }
}

class InfoDetailCard extends StatefulWidget {
  InfoDetailCard({Key? key, required this.isNew, this.info}) : super(key: key);

  final bool isNew;
  final Info? info;

  @override
  _InfoDetailCardState createState() => _InfoDetailCardState();
}

class _InfoDetailCardState extends State<InfoDetailCard> {
  var contentController = TextEditingController();
  late Future<List<Template>?> templates;
  int? dropdownValue;

  @override
  void initState() {
    super.initState();

    templates = Template.get("", "all");
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleList = [
      SizedBox(
          child: Center(
            child: Text(
              "标题：",
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50),
      SizedBox(
        height: 10,
      ),
      SizedBox(
          child: Center(
            child: Text(
              "内容：",
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 100),
      SizedBox(
        height: 10,
      ),
    ];
    List<Widget> contentList = [
      SizedBox(
        height: 50,
        child: widget.isNew
            ? FutureWidget<List<Template>>(
                future: (context) => templates,
                builder: (context, result) {
                  List<DropdownMenuItem<int>> templateList = [];
                  if (widget.isNew) {
                    for (var template in result) {
                      var templateItem = DropdownMenuItem<int>(
                          child: Text(template.title),
                          value: template.templateId);
                      templateList.add(templateItem);
                    }
                  }

                  return DropdownButton<int>(
                    items: templateList,
                    value: dropdownValue,
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  widget.info!.title,
                  style: InfoDetailCardTitleTextStyle,
                ),
              ),
      ),
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: contentController,
        maxLines: 6,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ];

    if (!widget.isNew) {
      contentController.text = widget.info!.content!;

      titleList.add(
        SizedBox(
            child: Center(
              child: Text(
                "创建时间：",
                style: InfoDetailCardTitleTextStyle,
              ),
            ),
            height: 50),
      );
      titleList.add(
        SizedBox(
          height: 10,
        ),
      );
      titleList.add(
        SizedBox(
            child: Center(
              child: Text(
                "更新时间：",
                style: InfoDetailCardTitleTextStyle,
              ),
            ),
            height: 50),
      );
      titleList.add(
        SizedBox(
          height: 10,
        ),
      );

      contentList.add(SizedBox(
          child: Center(
            child: Text(
              widget.info!.createTime!,
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50));
      contentList.add(
        SizedBox(
          height: 10,
        ),
      );
      contentList.add(SizedBox(
          child: Center(
            child: Text(
              widget.info!.modifyTime,
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50));
      contentList.add(
        SizedBox(
          height: 10,
        ),
      );
    }

    return NeuomorphicContainer(
      child: Padding(
        padding: new EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: titleList,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: contentList,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: widget.isNew
                      ? Text("")
                      : MyAlertButton(
                          child: Text(
                            "删除",
                            style: InfoDetailCardTitleTextStyle,
                          ),
                          onTap: () {
                            _removeInfo(widget.info!.infoId);
                          },
                        ),
                ),
                Expanded(
                  child: MyButton(
                    child: Text(
                      "保存",
                      style: InfoDetailCardTitleTextStyle,
                    ),
                    onTap: () {
                      _saveInfo(widget.isNew, widget.info?.infoId);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      borderRadius: BorderRadius.circular(15.0),
      color: Color.fromRGBO(239, 238, 238, 1.0),
      style: NeuomorphicStyle.Flat,
      // intensity: 0.35,
      offset: Offset(15, 15),
      blur: 30,
    );
  }
}

void _removeInfo(int infoId) {
  // TODO
}

void _saveInfo(bool isNew, int? infoId) {
  if (isNew) {
    // TODO
  } else {
    // TODO
  }
}

const InfoDetailCardTitleTextStyle = const TextStyle(
  fontFamily: "Jiangcheng",
  fontSize: 18,
  fontWeight: FontWeight.w600,
);
