import 'dart:math';

import 'package:easy_pass/utils/app_theme.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
import 'package:toggle_switch/toggle_switch.dart';

class InfoView extends StatefulWidget {
  const InfoView({Key key}) : super(key: key);

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  int filterIndex = 1;
  List<String> titleList = [];
  String filterMethod = "我的";
  final searchController = TextEditingController();
  var random = Random(0);

  @override
  void initState() {
    refreshTitle();
  }

  void refreshTitle() async {
    setState(() {
      titleList.clear();
    });

    await Future.delayed(const Duration(microseconds: 1));
    // get infos here
    // TIP using streamBuilder ?

    setState(() {
      for (int i = 0; i < 10; i++) {
        int rand = random.nextInt(200);
        titleList.add('Title$rand $i');
      }
    });
  }

  void loadMoreInfo() async {
    // TODO
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
                  "信息",
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
                      if (index == 0) {
                        filterMethod = "所有";
                      } else {
                        filterMethod = "我的";
                      }
                    });
                    refreshTitle();
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
                      restorationId: "info_search_text_field",
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
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // child: AnimationLimiter(
            child: ListView.builder(
              itemCount: titleList.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == titleList.length + 1) {
                  return SizedBox(height: 50);
                }
                if (index == titleList.length) {
                  return Center(
                    child: MaterialButton(
                      child: Text("点击加载更多"),
                      onPressed: () {
                        loadMoreInfo();
                      },
                    ),
                  );
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
                        child: InfoCard(title: titleList[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ),
        ],
      ),
    );
  }
}

class InfoViewFloatingButton extends FloatingActionButton {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: AppTheme.lightGreen,
        child: Icon(Icons.add),
        onPressed: () {
          //TODO
        });
  }
}

class InfoCard extends StatelessWidget {
  InfoCard({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return NeuomorphicContainer(
      child: Padding(
        padding: new EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.title,
              style: InfoCardTitleTextStyle,
            ),
            SizedBox(
              height: 30,
              child: Text("content"),
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
    );
  }
}

const InfoCardTitleTextStyle = const TextStyle(
  fontFamily: "Jiangcheng",
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
