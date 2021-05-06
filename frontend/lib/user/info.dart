import 'package:easyPass/utils/bottom_bar.dart';
import 'package:easyPass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoPage extends StatefulWidget {
  InfoPage();

  @override
  _InfoPageState createState() => new _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                  child: Text(
                    // TODO 移动位置
                    "信息",
                    style: TitleTextStyle,
                  ),
                ),
                Row(
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
                        child: SvgPicture.asset(
                          'assets/images/icon/sousuo.svg',
                          color: Colors.white,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: new EdgeInsets.only(top: 40),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        MyInfoCard(
                          categoryName: "test1",
                        ),
                        MyInfoCard(
                          categoryName: "test2",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomBar(
            selectedPage: 'info',
          ),
        ],
      ),
    );
  }
}
