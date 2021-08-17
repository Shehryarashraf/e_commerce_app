import 'package:e_commerce_app/screens/constants.dart';
import 'package:e_commerce_app/screens/widgets/bottom_tabs.dart';
import 'package:e_commerce_app/services/firebase_services.dart';
import 'package:e_commerce_app/tabs/home_tab.dart';
import 'package:e_commerce_app/tabs/saved_tab.dart';
import 'package:e_commerce_app/tabs/search_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  PageController _tabsPageController;
  int _selectedtab = 0;

  @override
  void initState() {
    _tabsPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PageView(
            controller: _tabsPageController,
            onPageChanged: (num) {
              setState(() {
                _selectedtab = num;
              });
            },
            children: [HomeTab(), SearchTab(), SavedTab()],
          ),
        ),
        BottomTabs(
          selectedTab: _selectedtab,
          tabPressed: (num) {
            _tabsPageController.animateToPage(num,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInCubic);
          },
        )
      ],
    ));
  }
}
