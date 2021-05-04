import 'package:easyPass/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TitleTextStyle = const TextStyle(
  fontFamily: "Jiangcheng",
  fontSize: 40,
  fontWeight: FontWeight.w600,
);

class MyTextField extends StatelessWidget {
  const MyTextField({
    this.hintText,
    this.restorationId,
    this.controller,
    this.obscurText = false,
  });

  final String hintText;
  final String restorationId;
  final bool obscurText;
  final TextEditingController controller;

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
          controller: controller,
          textInputAction: TextInputAction.next,
          restorationId: this.restorationId,
          cursorColor: AppTheme.buildLightTheme().primaryColor,
          obscureText: this.obscurText,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: this.hintText,
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({this.child, this.onTap, this.radius = 45.0});

  final Widget child;
  final double radius;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.buildLightTheme().primaryColor,
        borderRadius: new BorderRadius.all(
          Radius.circular(this.radius),
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
          borderRadius: new BorderRadius.all(
            Radius.circular(this.radius),
          ),
          onTap: this.onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: this.child,
          ),
        ),
      ),
    );
  }
}
