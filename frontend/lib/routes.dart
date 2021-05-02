import 'dart:js';

import 'package:easyPass/regitster.dart';
import 'package:easyPass/user/accounts.dart';
import 'package:easyPass/user/home.dart';
import 'package:easyPass/user/info.dart';
import 'package:easyPass/user/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easyPass/welcome.dart';
import 'package:easyPass/test.dart';
import 'package:easyPass/login.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, List<String>);

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
const loginRoute = '/login';
const registerRoute = '/register';

const homeRoute = '/home';
const infoRoute = '/info';
const accountsRoute = '/accounts';
const settingsRoute = '/settings';

class Routeconfiguration {
  /// 所有的需要进行正则匹配的path
  static List<Path> paths = [
    Path(testRoute, (context, segments) => TestPage(segments: segments)),
    Path(registerRoute, (context, segments) => RegisterPage()),
    Path(loginRoute, (context, segments) => LoginPage()),
    Path(homeRoute, (context, segments) => HomePage()),
    Path(accountsRoute, (context, segments) => AccountsPage()),
    Path(infoRoute, (context, segments) => InfoPage()),
    Path(settingsRoute, (context, segments) => SettingsPage()),
    Path(welcomeRoute, (context, segments) => WelcomePage()),
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (final path in paths) {
      final regExpPattern = RegExp(r'^' + path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        List<String> segmentsTmp;
        if (settings.name.length > path.pattern.length) {
          final lastFragment = settings.name.substring(path.pattern.length + 1);
          segmentsTmp = lastFragment.split('/');
        }
        final segments = segmentsTmp;

        if (kIsWeb) {
          return NoAnimationMaterialPageRoute<void>(
            builder: (context) => path.builder(context, segments),
            settings: settings,
          );
        }
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, segments),
          settings: settings,
        );
      }
    }

    return null;
  }
}

/// 专门用于在电脑上显示的MaterialPage，去掉了手机上的动画效果
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
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
