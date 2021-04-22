import 'package:easyPass/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
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
                  _UsernameTextField(),
                  SizedBox(height: 40),
                  _PasswordTextField(),
                  SizedBox(height: 100),
                  _LoginButton(),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('没有账号？'),
                      MaterialButton(
                        child: Text("点此注册"),
                        textColor: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
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

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.buildLightTheme().backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(38.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: TextField(
          textInputAction: TextInputAction.next,
          restorationId: 'username_text_field',
          cursorColor: AppTheme.buildLightTheme().primaryColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '用户名',
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.buildLightTheme().backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(38.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: TextField(
          textInputAction: TextInputAction.next,
          restorationId: 'password_text_field',
          cursorColor: AppTheme.buildLightTheme().primaryColor,
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '密码',
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.buildLightTheme().primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(45.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(45.0),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(FontAwesomeIcons.arrowRight,
                size: 50, color: AppTheme.buildLightTheme().backgroundColor),
          ),
        ),
      ),
    );
  }
}
