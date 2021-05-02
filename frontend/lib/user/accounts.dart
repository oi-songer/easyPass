import 'package:easyPass/utils/bottom_bar.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text("This is accounts page."),
          ),
          BottomBar(
            selectedPage: 'accounts',
          ),
        ],
      ),
    );
  }
}
