import 'package:easy_pass/company/template.dart';
import 'package:easy_pass/model/template.dart';
import 'package:easy_pass/utils/app_theme.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fsuper/fsuper.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:useful_widgets/widgets/future/future_widget.dart';

class TemplateView extends StatefulWidget {
  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  int filterIndex = 1;
  String filterMethod = "mine";
  late Future<List<Template>?> templateList;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    templateList = Template.get("", "mine");
  }

  void refreshTemplates() async {
    if (filterIndex == 0) {
      filterMethod = "all";
    } else {
      filterMethod = "mine";
    }
    setState(() {
      templateList = Template.get(
        searchController.text,
        filterMethod,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  "信息类目",
                  style: TitleTextStyle,
                ),
                Expanded(child: SizedBox()),
                ToggleSwitch(
                  initialLabelIndex: filterIndex,
                  minWidth: 70.0,
                  cornerRadius: 20.0,
                  activeBgColor: AppTheme.mainGreen,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  labels: ["所有", "我的"],
                  onToggle: (index) {
                    setState(() {
                      filterIndex = index;
                    });
                    refreshTemplates();
                    // TODO refresh
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: new EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: new EdgeInsets.only(left: 20, right: 20),
                    child: MyTextField(
                      hintText: "Search",
                      restorationId: "template_search_text_field",
                      controller: searchController,
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(left: 20, right: 20),
                  child: MyButton(
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          FutureWidget<List<Template>>(
              future: (context) => templateList,
              awaitWidget: (context) => MyAwaitWidget(),
              builder: (context, result) {
                return Expanded(
                  // child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: result.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == result.length) {
                        return SizedBox(height: 50);
                      }

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 200),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: new EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              child: TemplateCard(
                                  template:
                                      result[index]), //accountList[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  TemplateCard({Key? key, required this.template}) : super(key: key);

  final Template template;

  @override
  Widget build(BuildContext context) {
    List<Widget> tagList = [];
    if (template.requirementId == null) {
      tagList.add(FSuper(
        text: "无权限",
        strokeWidth: 1,
        style: TextStyle(
            color: Colors.grey,
            fontFamily: "Oppo Sans",
            fontWeight: FontWeight.w600),
        corner: FCorner.all(16),
        cornerStyle: FCornerStyle.round,
        padding: EdgeInsets.fromLTRB(9, 2, 9, 2),
        strokeColor: Colors.grey,
      ));
    } else {
      if (template.optional!) {
        tagList.add(FSuper(
          text: "可选权限",
          strokeWidth: 1,
          style: TextStyle(color: Colors.orange, fontFamily: "Oppo Sans"),
          corner: FCorner.all(16),
          cornerStyle: FCornerStyle.round,
          padding: EdgeInsets.fromLTRB(9, 2, 9, 2),
          strokeColor: Colors.orange,
        ));
      } else {
        tagList.add(FSuper(
          text: " 有权限 ",
          strokeWidth: 1,
          style: TextStyle(color: Colors.green, fontFamily: "Oppo Sans"),
          corner: FCorner.all(16),
          cornerStyle: FCornerStyle.round,
          padding: EdgeInsets.fromLTRB(9, 2, 9, 2),
          strokeColor: Colors.green,
        ));
      }
      tagList.add(SizedBox(
        width: 10,
      ));

      if (template.permission == 'all') {
        tagList.add(FSuper(
          text: "读写",
          strokeWidth: 1,
          style: TextStyle(color: Colors.green, fontFamily: "Oppo Sans"),
          corner: FCorner.all(16),
          cornerStyle: FCornerStyle.round,
          padding: EdgeInsets.fromLTRB(9, 2, 9, 2),
          strokeColor: Colors.green,
        ));
      } else if (template.permission == 'read') {
        tagList.add(FSuper(
          text: "只读",
          strokeWidth: 1,
          style: TextStyle(color: Colors.cyan, fontFamily: "Oppo Sans"),
          corner: FCorner.all(16),
          cornerStyle: FCornerStyle.round,
          padding: EdgeInsets.fromLTRB(9, 2, 9, 2),
          strokeColor: Colors.cyan,
        ));
      }
    }

    return InkWell(
      onTap: () {
        // TODO
        Navigator.of(context).pushNamed('/template',
            arguments: TemplateArguments(template: template));
      },
      child: NeuomorphicContainer(
        child: Padding(
          padding: new EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.title,
                style: InfoCardTitleTextStyle,
              ),
              SizedBox(
                height: 30,
                child: Row(
                  children: tagList,
                  // 各种状态标签
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.more_horiz,
                ),
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
      ),
    );
  }
}
