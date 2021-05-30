import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';

class UserSettingView extends StatefulWidget {
  const UserSettingView({Key? key}) : super(key: key);

  @override
  _UserSettingViewState createState() => _UserSettingViewState();
}

class _UserSettingViewState extends State<UserSettingView> {
  bool useFingerprint = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: new EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Username",
              style: TextStyle(
                fontFamily: "Jiangcheng",
                fontSize: 50,
              ),
            ),
            Divider(),
            MaterialButton(
              height: 100,
              child: Row(
                children: [
                  Text(
                    "修改个人信息",
                    style: SettingTextStyle,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Icon(Icons.navigate_next),
                ],
              ),
              onPressed: () {},
            ),
            MaterialButton(
              height: 100,
              child: Row(
                children: [
                  Text(
                    "修改密码",
                    style: SettingTextStyle,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Icon(Icons.navigate_next),
                ],
              ),
              onPressed: () {},
            ),
            MaterialButton(
              height: 100,
              child: Row(
                children: [
                  Text(
                    "使用指纹登录",
                    style: SettingTextStyle,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Switch(
                      value: useFingerprint,
                      onChanged: (value) {
                        // TODO
                        setState(() {
                          useFingerprint = value;
                        });
                      }),
                ],
              ),
              onPressed: () {},
            ),
            MyAlertButton(
              child: Padding(
                padding: new EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  "退出登录",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

const SettingTextStyle = const TextStyle(
  fontSize: 20,
);
