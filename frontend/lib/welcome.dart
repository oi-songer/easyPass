import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 80),
          Center(
            child: SvgPicture.asset(
              'assets/images/logo/easypass-logo-with-text.svg',
            ),
          ),
          SizedBox(height: 120),
          Center(
            child: MyButton(
                child: Text("用户登录"),
                onTap: () {
                  Navigator.of(context).pushNamed('/login');
                }),
          ),
        ],
      ),
    );
  }
}
