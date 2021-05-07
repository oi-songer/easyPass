import 'package:easy_pass/login.dart';
import 'package:easy_pass/utils/bottom_bar.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkLogin().then((valid) {
      if (valid == false) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                  child: Text(
                    // TODO 移动位置
                    "主页",
                    style: TitleTextStyle,
                  ),
                ),
                // TODO add content
              ],
            ),
          ),
          BottomBar(
            selectedPage: 'home',
          ),
        ],
      ),
    );
  }
}
