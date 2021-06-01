import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanySettingView extends StatefulWidget {
  const CompanySettingView({Key? key}) : super(key: key);

  @override
  _CompanySettingViewState createState() => _CompanySettingViewState();
}

class _CompanySettingViewState extends State<CompanySettingView> {
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
                    "修改企业信息",
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
              onTap: () {
                _logout(context);
              },
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

void _logout(context) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.remove('companyToken');

  Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
}
