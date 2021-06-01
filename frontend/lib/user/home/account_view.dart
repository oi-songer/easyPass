import 'dart:math';

import 'package:easy_pass/model/account.dart';
import 'package:easy_pass/user/account.dart';
import 'package:easy_pass/utils/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:neuomorphic_container/neuomorphic_container.dart';
import 'package:useful_widgets/widgets/future/future_widget.dart';
// import 'package:toggle_switch/toggle_switch.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late Future<List<Account>?> accountList;
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    accountList = Account.get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  "账号",
                  style: TitleTextStyle,
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          Padding(
            padding: new EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
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
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          FutureWidget<List<Account>>(
              future: (context) => accountList,
              builder: (context, result) {
                return Expanded(
                  // child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: result.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == result.length) {
                        return SizedBox(height: 50);
                      }

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 200),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: new EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              child: AccountCard(
                                  account:
                                      result[index]), //accountList[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
          // ),
        ],
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  AccountCard({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/account',
            arguments: AccountArguments(account: account));
      },
      child: NeuomorphicContainer(
        child: Padding(
          padding: new EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.companyName,
                style: AccountCardTitleTextStyle,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.more_horiz,
                ),
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
      ),
    );
  }
}

const AccountCardTitleTextStyle = const TextStyle(
  fontFamily: "Jiangcheng",
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
