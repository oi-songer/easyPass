import 'package:easy_pass/login.dart';
import 'package:easy_pass/utils/bottom_bar.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage();

  @override
  _AccountsPageState createState() => new _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    checkLogin().then((valid) {
      if (valid == false) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                  child: Text(
                    // TODO 移动位置
                    "账号",
                    style: TitleTextStyle,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: new EdgeInsets.only(left: 20, right: 20),
                        child: MyTextField(
                          hintText: "Search",
                          restorationId: "info_search_text_field",
                          controller: searchController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.only(left: 20, right: 20),
                      child: MyButton(
                        child: SvgPicture.asset(
                          'assets/images/icon/sousuo.svg',
                          color: Colors.white,
                          height: 30,
                          width: 30,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: new EdgeInsets.only(top: 40),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        MyAccountCard(
                          companyName: "Baidu",
                          infoCount: 10,
                          accountName: "username_in_baidu",
                          loginTime: "2021/05/03",
                        ),
                        MyAccountCard(
                          companyName: "Tencent",
                          infoCount: 10,
                          accountName: "username_in_tencent",
                          loginTime: "2021/05/03",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomBar(
            selectedPage: 'accounts',
          ),
        ],
      ),
    );
  }
}
