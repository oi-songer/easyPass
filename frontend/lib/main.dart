import 'dart:io';

import 'package:easy_pass/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(EasyPassApp());
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      // TIP
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

class EasyPassApp extends StatelessWidget {
  const EasyPassApp({
    Key? key,
    // this.initialRoute,
  }) : super(key: key);

  // final String initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyPass',
      onGenerateRoute: Routeconfiguration.onGenerateRoute,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.white,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// // TODO
// class BackWrapper extends StatefulWidget {
//   const BackWrapper({
//     Key key,
//     this.back,
//     this.alignment = AlignmentDirectional.bottomStart,
//   }) : super(key: key);

//   final Widget back;
//   final AlignmentDirectional alignment;

//   @override
//   _BackWrapperState createState() => _BackWrapperState();
// }
