import 'package:easy_pass/model/requirement.dart';
import 'package:easy_pass/model/template.dart';
import 'package:easy_pass/user/info.dart';
import 'package:easy_pass/utils/app_theme.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:easy_pass/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TemplateArguments {
  TemplateArguments({required this.template});

  Template template;
}

class TemplatePage extends StatefulWidget {
  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  late Template template;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TemplateArguments;
    template = args.template;

    return Scaffold(
      body: Column(
        children: [
          Text(
            "类目",
            style: TitleTextStyle,
          ),
          Padding(
            padding: new EdgeInsets.all(10),
            child: TemplateDetailCard(
              template: template,
            ),
          ),
        ],
      ),
    );
  }
}

class TemplateDetailCard extends StatefulWidget {
  TemplateDetailCard({Key? key, required this.template}) : super(key: key);

  final Template template;

  @override
  _TemplateDetailCardState createState() => _TemplateDetailCardState();
}

class _TemplateDetailCardState extends State<TemplateDetailCard> {
  late int reqToggleIndex;
  late int permissionToggleIndex;

  @override
  void initState() {
    super.initState();

    if (widget.template.requirementId == null) {
      reqToggleIndex = 0;
    } else if (widget.template.optional!) {
      reqToggleIndex = 1;
    } else {
      reqToggleIndex = 2;
    }

    if (widget.template.permission == 'all') {
      permissionToggleIndex = 1;
    } else {
      permissionToggleIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    children: [
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
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                          child: Center(
                            child: Text(
                              widget.template.title,
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
                              widget.template.description,
                              style: InfoDetailCardTitleTextStyle,
                            ),
                          ),
                          height: 100),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ToggleSwitch(
              initialLabelIndex: reqToggleIndex,
              minWidth: 70.0,
              cornerRadius: 20.0,
              activeBgColor: AppTheme.mainGreen,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              labels: ["无权限", "可选", "有权限"],
              onToggle: (index) {
                setState(() {
                  reqToggleIndex = index;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ToggleSwitch(
              initialLabelIndex: permissionToggleIndex,
              minWidth: 70.0,
              cornerRadius: 20.0,
              activeBgColor: AppTheme.mainGreen,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              labels: ["只读", "读写"],
              onToggle: (index) {
                setState(() {
                  permissionToggleIndex = index;
                });
              },
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  child: MyButton(
                    child: Text(
                      "保存",
                      style: InfoDetailCardTitleTextStyle,
                    ),
                    onTap: () {
                      _saveReq(context, reqToggleIndex, permissionToggleIndex,
                          widget.template);
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

void _saveReq(BuildContext context, int reqToggleIndex, permissionIndex,
    Template template) async {
  String permission = 'all';
  bool optional = false;

  if (reqToggleIndex == 1) optional = true;
  if (permissionIndex == 0) permission = 'read';

  String? msg;
  bool mark = false;
  if (template.requirementId == null && reqToggleIndex != 0) {
    msg = await Requirement.create(template.templateId, permission, optional);
  } else if (template.requirementId != null && reqToggleIndex == 0) {
    msg = await Requirement.remove(template.templateId);
    mark = true;
  } else {
    msg = await Requirement.modify(template.templateId, permission, optional);
  }

  if (msg != null) {
    toast(msg);
    if (mark) {
      Navigator.of(context).pop();
    }
  }
}
