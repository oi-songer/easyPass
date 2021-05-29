import 'package:easy_pass/login.dart';
import 'package:easy_pass/utils/app_theme.dart';
import 'package:easy_pass/utils/bottom_bar.dart';
import 'package:easy_pass/utils/components.dart';
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
    checkLogin().then((valid) {
      if (valid == false) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.mainGreen,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/editInfo/new');
        },
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        FloatingActionButtonLocation.endFloat,
        0,
        -60,
      ),
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
                          onTap: () {}),
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
                          content: "",
                        ),
                        MyInfoCard(
                          categoryName: "test2",
                          content: "",
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

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
