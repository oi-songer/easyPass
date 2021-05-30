import 'package:easy_pass/utils/bottom_bar.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SummaryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: Row(children: [
              Text(
                // TODO 移动位置
                "首页",
                textAlign: TextAlign.left,
                style: TitleTextStyle,
              ),
              Expanded(child: SizedBox()),
              MaterialButton(
                child: Icon(Icons.scanner),
                color: Colors.grey,
                onPressed: () {
                  scan();
                },
              )
            ]),
          ),
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Text("Element"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
