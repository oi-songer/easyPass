import 'package:easyPass/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(EasyPassApp());
}

class EasyPassApp extends StatelessWidget {
  const EasyPassApp({
    Key key,
    this.initialRoute,
  }) : super(key: key);

  final String initialRoute;

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
        primarySwatch: Colors.blue,
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

// class _BackWrapperState extends State<BackWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     final ColorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//     return Stack(
//       children: [
//         RestorationScope(
//           restorationId: 'back_wrapper',
//           child: widget.back,
//         ),
//         SafeArea(
//           child: Align(
//               alignment: widget.alignment,
//               child: FloatingActionButton.extended(
//                   heroTag: _BackButtonHeroTag(),
//                   key: const ValueKey('Back'),
//                   onPressed: () {
//                     Navigator.of(context)
//                         .popUntil((route) => route.settings.name == '/');
//                   },
//                   icon: IconTheme(
//                     data: IconThemeData(color: ColorScheme.onPrimary),
//                     child: const BackButtonIcon(),
//                   ),
//                   label: Text(
//                     MaterialLocalizations.of(context).backButtonTooltip,
//                     style: textTheme.button.apply(color: ColorScheme.onPrimary),
//                   ))),
//         )
//       ],
//     );
//   }
// }

// class _BackButtonHeroTag {}
