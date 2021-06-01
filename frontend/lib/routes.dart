import 'package:easy_pass/company/home/home.dart';
import 'package:easy_pass/company/login.dart';
import 'package:easy_pass/company/register.dart';
import 'package:easy_pass/company/template.dart';
import 'package:easy_pass/user/register.dart';
import 'package:easy_pass/user/account.dart';
import 'package:easy_pass/user/home/home.dart';
import 'package:easy_pass/user/info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_pass/welcome.dart';
import 'package:easy_pass/test.dart';
import 'package:easy_pass/user/login.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext);

/// Path类中包含一个用于匹配路径的正则str，和一个用于构造实际页面内容的builder
class Path {
  const Path(this.pattern, this.builder);

  final String pattern;

  // 分别指网页端的builder和手机端的builder，
  // 如果初始化时没有输入phoneBuilder，
  // 则手机也会使用webBuilder
  final PathWidgetBuilder builder;
}

const welcomeRoute = '/';
const testRoute = '/test'; // TODO

// user pages
const loginRoute = '/login';
const registerRoute = '/register';
const homeRoute = '/home';
const infoRoute = '/info';
const accountRoute = '/account';

// company pages
const companyLoginRoute = '/company/login';
const companyRegisterRoute = '/company/register';
const companyHomeRoute = '/company/home';
const templateRoute = '/template';

// admin pages
const adminHomeRoute = '/admin/home';

class Routeconfiguration {
  /// 所有的需要进行正则匹配的path
  static List<Path> paths = [
    // test
    Path(testRoute, (context) => TestPage()),
    // user
    Path(registerRoute, (context) => RegisterPage()),
    Path(loginRoute, (context) => LoginPage()),
    Path(homeRoute, (context) => HomePage()),
    Path(infoRoute, (context) => InfoPage()),
    Path(accountRoute, (context) => AccountPage()),
    // company
    Path(companyLoginRoute, (context) => CompanyLoginPage()),
    Path(companyRegisterRoute, (context) => CompanyRegisterPage()),
    Path(companyHomeRoute, (context) => CompanyHomePage()),
    Path(templateRoute, (context) => TemplatePage()),
    // all
    Path(welcomeRoute, (context) => WelcomePage()),
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (final path in paths) {
      final regExpPattern = RegExp(r'^' + path.pattern);
      if (regExpPattern.hasMatch(settings.name!)) {
        if (kIsWeb) {
          return NoAnimationMaterialPageRoute<void>(
            builder: (context) => path.builder(context),
            settings: settings,
          );
        }

        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context),
          settings: settings,
        );
      }
    }

    return MaterialPageRoute<void>(
      builder: (context) => paths[paths.length].builder(context),
      settings: settings,
    );
  }
}

/// 专门用于在电脑上显示的MaterialPage，去掉了手机上的动画效果
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
