import 'dart:math' as math;

import 'package:easy_pass/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:barcode_scan/barcode_scan.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({this.selectedPage});

  final String selectedPage;

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: SizedBox(),
        ),
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                color: AppTheme.white,
                elevation: 16.0,
                clipper: TabClipper(
                  radius: 38.0,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 62,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWellSplash(
                                      splashFactory: InkRipple.splashFactory,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          widget.selectedPage == 'home'
                                              ? 'assets/images/icon/shouye.svg'
                                              : 'assets/images/icon/shouye_before.svg',
                                          width: 40,
                                        ),
                                      ),
                                      // splashColor: AppTheme.lightGreen,
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWellSplash(
                                      splashFactory: InkRipple.splashFactory,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          widget.selectedPage == 'accounts'
                                              ? 'assets/images/icon/jiankong.svg'
                                              : 'assets/images/icon/jiankong_before.svg',
                                          width: 40,
                                        ),
                                      ),
                                      // splashColor: AppTheme.lightGreen,
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/accounts');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 64,
                              ),
                              Expanded(
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWellSplash(
                                      splashFactory: InkRipple.splashFactory,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          widget.selectedPage == 'info'
                                              ? 'assets/images/icon/wenjian.svg'
                                              : 'assets/images/icon/wenjian_before.svg',
                                          width: 40,
                                        ),
                                      ),
                                      // splashColor: AppTheme.lightGreen,
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/info');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWellSplash(
                                      splashFactory: InkRipple.splashFactory,
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          widget.selectedPage == 'settings'
                                              ? 'assets/images/icon/shezhi.svg'
                                              : 'assets/images/icon/shezhi_before.svg',
                                          width: 40,
                                        ),
                                      ),
                                      // splashColor: AppTheme.lightGreen,
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/settings');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: SizedBox(
                width: 38 * 2.0,
                height: 38 + 62.0,
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Colors.transparent,
                  child: SizedBox(
                    width: 38 * 2.0,
                    height: 38 * 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.nearlyBlack,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.heavyGreen,
                              AppTheme.mainGreen,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppTheme.heavyGreen.withOpacity(0.4),
                              offset: const Offset(8.0, 16.0),
                              blurRadius: 16.0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.white.withOpacity(0.1),
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            onTap: () {
                              scan();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                'assets/images/icon/saoma_before.svg',
                                color: AppTheme.nearlyWhite,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }
}

//  扫描二维码
Future scan() async {
  try {
    // 此处为扫码结果，barcode为二维码的内容
    String barcode = await BarcodeScanner.scan();
    print('扫码结果: ' + barcode);
    // TODO 跳转到确认界面
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      // 未授予APP相机权限
      // TODO 使用弹窗提示
      print('未授予APP相机权限');
    } else {
      // 扫码错误
      print('扫码错误: $e');
    }
  } on FormatException {
    // 进入扫码页面后未扫码就返回
    print('进入扫码页面后未扫码就返回');
  } catch (e) {
    // 扫码错误
    print('扫码错误: $e');
  }
}
