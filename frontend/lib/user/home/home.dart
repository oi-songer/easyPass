import 'package:easy_pass/user/account.dart';
import 'package:easy_pass/user/info.dart';
import 'package:easy_pass/user/home/account_view.dart';
import 'package:easy_pass/user/home/info_view.dart';
import 'package:easy_pass/user/home/setting_view.dart';
import 'package:easy_pass/user/home/summary_view.dart';
import 'package:easy_pass/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late MotionTabController _tabController;
  FloatingActionButton? floatingButton;

  void changeFloatingButton(BuildContext context) {
    setState(() {
      // set different params when in different page
      if (_tabController.index == 0 ||
          _tabController.index == 3 ||
          _tabController.index == 1) {
        floatingButton = null;
      } else if (_tabController.index == 2) {
        floatingButton = FloatingActionButton(
            backgroundColor: AppTheme.lightGreen,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/info', arguments: InfoArguments(isNew: true));
            });
      }
      // } else if (_tabController.index == 1) {
      //   floatingButton = FloatingActionButton(
      //       backgroundColor: AppTheme.lightGreen,
      //       child: Icon(Icons.add),
      //       onPressed: () {
      //         Navigator.of(context).pushNamed('/account',
      //             arguments: AccountArguments(isNew: true));
      //       });
    });
  }

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
      body: Column(
        children: [
          // TIP
          SizedBox(height: MediaQuery.of(context).padding.top),
          Expanded(
            child: MotionTabBarView(
              controller: _tabController,
              children: [
                SummaryView(),
                AccountView(),
                InfoView(),
                UserSettingView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingButton,
      bottomNavigationBar: MotionTabBar(
        labels: ['首页', '账号', '信息', '设置'],
        initialSelectedTab: '首页',
        tabIconColor: AppTheme.lightGreen,
        tabSelectedColor: AppTheme.mainGreen,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController.index = value;
          });
          changeFloatingButton(context);
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
