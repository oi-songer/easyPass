import 'package:easy_pass/model/company.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:useful_widgets/widgets/future/future_widget.dart';

import 'model/user.dart';

class WelcomePage extends StatelessWidget {
  Future<bool> checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("userToken")) {
      bool check = await User.check();
      if (check == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } else if (prefs.containsKey("companyToken")) {
      bool check = await Company.check();
      if (check == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/company/home', (route) => false);
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureWidget<bool>(
        future: (context) => checkLogin(context),
        awaitWidget: (context) => MyAwaitWidget(),
        builder: (context, result) => Column(
          children: [
            SizedBox(height: 80),
            Center(
              child: SvgPicture.asset(
                'assets/images/logo/easypass-logo-with-text.svg',
              ),
            ),
            SizedBox(height: 120),
            Center(
              child: Column(
                children: [
                  MyButton(
                    child: Text("用户登录"),
                    onTap: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyButton(
                    child: Text("企业用户登录"),
                    onTap: () {
                      Navigator.of(context).pushNamed('/company/login');
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyButton(
                    child: Text("测试界面"),
                    onTap: () {
                      Navigator.of(context).pushNamed('/test');
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyButton(
                    child: Text("用户界面"),
                    onTap: () {
                      Navigator.of(context).pushNamed('/home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
