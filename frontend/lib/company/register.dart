import 'dart:convert';

import 'package:easy_pass/model/company.dart';
import 'package:easy_pass/model/user.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyRegisterPage extends StatefulWidget {
  CompanyRegisterPage();

  @override
  _CompanyRegisterPageState createState() => new _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends State<CompanyRegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final descriptionController = TextEditingController();
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
                    hintText: "简介",
                    restorationId: "description_text_field",
                    controller: descriptionController,
                  ),
                  SizedBox(height: 30),
                  // _LoginButton(),
                  MyButton(
                      child: Text("注册"),
                      onTap: () {
                        var username = usernameController.text;
                        var password = passwordController.text;
                        var repeatPassword = repeatPasswordController.text;
                        var description = descriptionController.text;

                        if (password != repeatPassword) {
                          Fluttertoast.showToast(
                              msg: "请保证两次密码输入一致",
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              webPosition: "center");
                        } else {
                          _register(context, username, password, description);
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
                          Navigator.of(context)
                              .pushReplacementNamed('/company/login');
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

void _register(context, username, password, description) async {
  String message = await Company.register(username, password, description);

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
