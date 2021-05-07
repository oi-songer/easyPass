import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              padding: new EdgeInsets.only(left: 40, right: 40),
              width: (constraints.maxWidth > 400) ? 400 : constraints.maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  SvgPicture.asset(
                    'assets/images/logo/easypass-logo-with-text.svg',
                  ),
                  SizedBox(height: 120),
                  MyTextField(
                    hintText: "用户名",
                    restorationId: "username_text_field",
                  ),
                  SizedBox(height: 40),
                  MyTextField(
                    hintText: "密码",
                    restorationId: "username_text_field",
                    obscurText: true,
                  ),
                  SizedBox(height: 40),
                  MyTextField(
                    hintText: "请重复密码",
                    restorationId: "username_text_field",
                    obscurText: true,
                  ),
                  SizedBox(height: 50),
                  // _LoginButton(),
                  MyButton(
                    child: Text("注册"),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('已有账号？'),
                      MaterialButton(
                        child: Text("点此登录"),
                        textColor: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
