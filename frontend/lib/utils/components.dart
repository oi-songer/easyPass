import 'package:easy_pass/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const TitleTextStyle = const TextStyle(
  fontFamily: "Jiangcheng",
  fontSize: 40,
  fontWeight: FontWeight.w600,
);

const InfoCardTitleTextStyle = const TextStyle(
  fontFamily: "Opps Sans",
  fontSize: 30,
  // color: AppTheme.mainGreen,
);

const InfoCardLeftTextStyle = const TextStyle(
  fontFamily: "Opps Sans",
  fontSize: 15,
  // color: AppTheme.heavyGreen,
);

class MyTextField extends StatelessWidget {
  const MyTextField({
    required this.hintText,
    this.restorationId,
    required this.controller,
    this.obscurText = false,
  });

  final String hintText;
  final String? restorationId;
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
  const MyButton({
    required this.child,
    required this.onTap,
    this.radius = 45.0,
  });

  final Widget child;
  final double radius;
  final void Function() onTap;

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

class MyAlertButton extends StatelessWidget {
  const MyAlertButton({
    required this.child,
    required this.onTap,
    this.radius = 45.0,
  });

  final Widget child;
  final double radius;
  // TIP  err: This Overlay widget cannot be marked as needing to build because the framework is already in the process of building widgets
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
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

class MyInfoCard extends StatelessWidget {
  const MyInfoCard({required this.categoryName, required this.content});

  final String categoryName;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // TODO
          },
          child: SizedBox(
            height: 170,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                color: AppTheme.white,
                child: Column(
                  children: [
                    Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: new EdgeInsets.only(
                          left: 30,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          categoryName,
                          style: InfoCardTitleTextStyle,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      indent: 20.0,
                      endIndent: 300.0,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: new EdgeInsets.only(left: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "内容：",
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                "创建日期：",
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                "编辑日期：",
                                style: InfoCardLeftTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "test_username",
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                "2021/05/01",
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                "2021/05/02",
                                style: InfoCardLeftTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Padding(
                        padding: new EdgeInsets.only(right: 10, bottom: 10),
                        child: Text("···"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAccountCard extends StatelessWidget {
  const MyAccountCard({
    required this.companyName,
    required this.accountName,
    required this.loginTime,
    required this.infoCount,
  });

  final String companyName;
  final String accountName;
  final String loginTime;

  final int infoCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // TODO
          },
          child: SizedBox(
            height: 170,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                color: AppTheme.white,
                child: Column(
                  children: [
                    Container(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: new EdgeInsets.only(
                          left: 30,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          companyName,
                          style: InfoCardTitleTextStyle,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.0,
                      indent: 20.0,
                      endIndent: 300.0,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: new EdgeInsets.only(left: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "账户名：",
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                "信息授权数量：",
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                "最后登录日期：",
                                style: InfoCardLeftTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accountName,
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                infoCount.toString(),
                                style: InfoCardLeftTextStyle,
                              ),
                              Text(
                                loginTime,
                                style: InfoCardLeftTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Padding(
                        padding: new EdgeInsets.only(right: 10, bottom: 10),
                        child: Text("···"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyAwaitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Text("加载中，请稍候")
          ],
        ),
      ),
    );
  }
}
