import 'dart:convert';

import 'package:easy_pass/model/user.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage();

  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final emailController = TextEditingController();
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
                  SizedBox(height: 40),
                  SvgPicture.asset(
                    'assets/images/logo/easypass-logo-with-text.svg',
                  ),
                  SizedBox(height: 60),
                  MyTextField(
                    hintText: "用户名",
                    restorationId: "username_text_field",
                    controller: usernameController,
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    hintText: "密码",
                    restorationId: "password_text_field",
                    obscurText: true,
                    controller: passwordController,
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    hintText: "请重复密码",
                    restorationId: "repeat_password_text_field",
                    obscurText: true,
                    controller: repeatPasswordController,
                  ),
                  SizedBox(height: 30),
                  MyTextField(
                    hintText: "邮箱",
                    restorationId: "email_text_field",
                    controller: emailController,
                  ),
                  SizedBox(height: 30),
                  // _LoginButton(),
                  MyButton(
                      child: Text("注册"),
                      onTap: () {
                        var username = usernameController.text;
                        var password = passwordController.text;
                        var repeatPassword = repeatPasswordController.text;
                        var email = emailController.text;

                        if (password != repeatPassword) {
                          Fluttertoast.showToast(
                              msg: "请保证两次密码输入一致",
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              webPosition: "center");
                        } else if (!emailCheck(email)) {
                          Fluttertoast.showToast(
                              msg: "邮箱格式不合法",
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              webPosition: "center");
                        } else {
                          _register(context, username, password, email);
                        }
                      }),
                  Expanded(
                    child: SizedBox(),
                  ),
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
                  SizedBox(
                    height: 20,
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

void _register(context, username, password, email) async {
  String message = await User.register(username, password, email);

  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      webPosition: "center");

  // var user = User(
  //   username: username,
  //   password: password,
  // );

  // user.register().then(
  //   (response) async {
  //     Fluttertoast.showToast(
  //         msg: response.data,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         webPosition: "center");
  //   },
  // );
}

bool emailCheck(String input) {
  if (input.isEmpty) return false;
  // 邮箱正则
  String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  return RegExp(regexEmail).hasMatch(input);
}
