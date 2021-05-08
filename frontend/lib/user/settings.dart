import 'package:easy_pass/login.dart';
import 'package:easy_pass/utils/bottom_bar.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkLogin().then((valid) {
      if (valid == false) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
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
                    "设置",
                    style: TitleTextStyle,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: new EdgeInsets.only(top: 40),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Divider(),
                        Row(),
                        Divider(),
                        Center(
                          child: MyAlertButton(
                            child: Text("退出账号"),
                            onTap: () {
                              _logout(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomBar(
            selectedPage: 'settings',
          ),
        ],
      ),
    );
  }
}

void _logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.remove('user').then((success) {
    if (success) {
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      Fluttertoast.showToast(
          msg: "登出失败",
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          webPosition: "center");
    }
  });
}
