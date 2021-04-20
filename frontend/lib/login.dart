import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

double _textScaleFactor(BuildContext context) {
  return 1.0;
}

double reducedTextScale(BuildContext context) {
  final textScaleFactor = _textScaleFactor(context);
  return textScaleFactor >= 1 ? (1 + textScaleFactor) / 2 : 1;
}

const _horizontalPadding = 24.0;
double desktopLoginScreenMainAreaWidth({BuildContext context}) {
  return min(
    360 * reducedTextScale(context),
    MediaQuery.of(context).size.width - 2 * _horizontalPadding,
  );
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: desktopLoginScreenMainAreaWidth(context: context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                SvgPicture.asset(
                  'assets/images/logo/easypass-logo-with-text.svg',
                ),
                SizedBox(height: 120),
                // _UsernameTextField(),
                SizedBox(height: 12),
                // _PasswordTextField(),
                // _CancelAndNextButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
