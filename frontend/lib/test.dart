import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  late MotionTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // dynamic args = ModalRoute.of(context).settings.arguments;
    // var arg = args == null ? '' : args['arg'];
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        labels: ["Account", "Home", "Dashboard"],
        initialSelectedTab: "Home",
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.green,
        onTabItemSelected: (int value) {
          print(value);
          setState(() {
            _tabController.index = value;
          });
        },
        icons: [Icons.account_box, Icons.home, Icons.menu],
        textStyle: TextStyle(color: Colors.red),
      ),
      appBar: AppBar(
        title: Text("test page"),
      ),
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: [
                Center(
                  child: Text("Test"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
