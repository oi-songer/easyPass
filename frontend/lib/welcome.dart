import 'package:easy_pass/utils/components.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body: Stack(
        children: [
          Center(
            child: MaterialButton(
                child: Text("This is button"),
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                }),
          ),
          MyInfoCard(
            categoryName: "test",
          ),
        ],
      ),
    );
  }
}
