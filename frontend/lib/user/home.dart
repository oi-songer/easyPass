import 'package:easyPass/utils/bottom_bar.dart';
import 'package:easyPass/utils/components.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: Row(
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
          )),
          BottomBar(
            selectedPage: 'home',
          ),
        ],
      ),
    );
  }
}
