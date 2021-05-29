import 'package:easy_pass/user/home/info_view.dart';
import 'package:easy_pass/user/home/summary_view.dart';
import 'package:easy_pass/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class HomePage extends StatefulWidget {
  final List<FloatingActionButton> floatButtonList = [
    null,
    FloatingActionButton(child: Icon(Icons.add)), // TODO
    InfoViewFloatingButton(),
    null,
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  MotionTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        new MotionTabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MotionTabBarView(
        controller: _tabController,
        children: [
          SummaryView(),
          Container(
            child: Center(
              child: Text("This is account page"),
            ),
          ),
          InfoView(),
          Container(
            child: Center(
              child: Text("This is setting page"),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatButtonList[_tabController.index],
      bottomNavigationBar: MotionTabBar(
        labels: ['首页', '账号', '信息', '设置'],
        initialSelectedTab: '首页',
        tabIconColor: AppTheme.lightGreen,
        tabSelectedColor: AppTheme.mainGreen,
        onTabItemSelected: (int value) {
          print(value);
          setState(() {
            _tabController.index = value;
          });
        },
        icons: [
          Icons.analytics,
          Icons.account_circle,
          Icons.list,
          Icons.settings,
        ],
        textStyle:
            TextStyle(color: AppTheme.nearlyBlack, fontFamily: "Jiangcheng"),
      ),
    );
  }
}
