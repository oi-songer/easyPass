import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easyPass/home.dart';
import 'package:easyPass/test.dart';

typedef PathWidgetBuilder = Widget Function(BuildContext, List<String>);

/// Path类中包含一个用于匹配路径的正则str，和一个用于构造实际页面内容的builder
class Path {
  const Path(this.pattern, this.builder);

  final String pattern;

  final PathWidgetBuilder builder;
}

const homeRoute = '/';
const testRoute = '/test'; // TODO

class Routeconfiguration {
  /// 所有的需要进行正则匹配的path
  static List<Path> paths = [
    Path(testRoute, (context, segments) => TestPage(segments: segments)),
    Path(homeRoute,
        (context, segments) => HomePage(segments: ["This is title test"])),
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
