import 'package:easy_pass/model/account.dart';
import 'package:easy_pass/user/info.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';

class AccountArguments {
  AccountArguments({required this.account});

  Account account;
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account? account;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as AccountArguments;
    account = args.account;

    return Scaffold(
      body: Column(
        children: [
          Text(
            "账号",
            style: TitleTextStyle,
          ),
          Padding(
            padding: new EdgeInsets.all(10),
            child: Expanded(
              child: AccountDetailCard(
                account: account!,
              ),
            ),
          ),
          // TODO add accounts here
        ],
      ),
    );
  }
}

class AccountDetailCard extends StatelessWidget {
  AccountDetailCard({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    List<Widget> titleList = [
      SizedBox(
          child: Center(
            child: Text(
              "标题：",
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50),
      SizedBox(
        height: 10,
      ),
      SizedBox(
          child: Center(
            child: Text(
              "描述：",
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50),
    ];
    List<Widget> contentList = [
      SizedBox(
          child: Center(
            child: Text(
              account.companyName,
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50),
      SizedBox(
        height: 10,
      ),
      SizedBox(
          child: Center(
            child: Text(
              account.companyDescription,
              style: InfoDetailCardTitleTextStyle,
            ),
          ),
          height: 50),
    ];

    return NeuomorphicContainer(
      child: Padding(
        padding: new EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: titleList,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: contentList,
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: MyAlertButton(
                    child: Text(
                      "删除",
                      style: InfoDetailCardTitleTextStyle,
                    ),
                    onTap: () {
                      _removeAccount(account.accountId);
                    },
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                )
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      borderRadius: BorderRadius.circular(15.0),
      color: Color.fromRGBO(239, 238, 238, 1.0),
      style: NeuomorphicStyle.Flat,
      // intensity: 0.35,
      offset: Offset(15, 15),
      blur: 30,
    );
  }
}

void _removeAccount(int accountId) {
  // TODO
}
