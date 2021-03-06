import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rt_gem/screens/calender_screen.dart';
import 'package:rt_gem/screens/receipt_screen.dart';
import 'package:rt_gem/widgets/isApp/views/add_grocery.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/add_receipt.dart';
import 'package:rt_gem/widgets/AnimatedIndexedStack.dart';
import 'package:rt_gem/widgets/custom_dialog/add_dialog/add_dialog.dart';
import 'package:rt_gem/widgets/isApp/bottom_navigation_view/bottom_bar_view.dart';
import 'package:rt_gem/widgets/isApp/bottom_navigation_view/tabIcon_data.dart';
import 'package:rt_gem/screens/home_screen.dart';
import 'package:rt_gem/widgets/widgets.dart';

import '../theme.dart';
import 'calender_screen.dart';
import 'profile_screen.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  bool isInReceipt = false;

  final List<IconData> _icons = const [
    Icons.home,
    Icons.calendar_today_rounded,
    Icons.receipt,
    Icons.account_box_rounded,
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomeScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _icons.length,
      child: kIsWeb
          ? Scaffold(
              appBar: Responsive.isDesktop(context)
                  ? PreferredSize(
                      preferredSize: Size(screenSize.width, 100.0),
                      child: CustomAppBar(
                        //currentUser: currentUser,
                        icons: _icons,
                        selectedIndex: _selectedIndex,
                        onTap: (index) => setState(() {
                          _selectedIndex = index;
                          index == 2 ? isInReceipt = true : isInReceipt = false;
                        }),
                      ),
                    )
                  : null,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (isInReceipt) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddReceipt()));
                  } else {
                    Responsive.isDesktop(context)
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog();
                            })
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddGrocery()));
                  }
                },
                tooltip: isInReceipt ? 'Add Receipt' : 'Add Items',
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation: Responsive.isDesktop(context)
                  ? FloatingActionButtonLocation.centerTop
                  : FloatingActionButtonLocation.endFloat,
              body: AnimatedIndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  HomeScreen(animationController: animationController),
                  CalenderScreen(animationController: animationController),
                  ReceiptScreen(),
                  ProfileScreen(),
                ],
              ),
              bottomNavigationBar: !Responsive.isDesktop(context)
                  ? Container(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      color: Colors.white,
                      child: CustomTabBar(
                        icons: _icons,
                        selectedIndex: _selectedIndex,
                        onTap: (index) => setState(() {
                          _selectedIndex = index;
                          if (index == 2) {
                            isInReceipt = true;
                          } else {
                            isInReceipt = false;
                          }
                        }),
                      ),
                    )
                  : const SizedBox.shrink(),
            )
          : Stack(
              children: <Widget>[
                tabBody,
                bottomBar(),
              ],
            ),
    );
  }

  Widget tabBody = Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          colors: <Color>[
            CustomTheme.loginGradientStart,
            CustomTheme.loginGradientEnd
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 1.0),
          stops: <double>[0.0, 1.0],
          tileMode: TileMode.clamp),
    ),
  );

  Widget bottomBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            if (isInReceipt) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddReceipt()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddGrocery()));
            }
          },
          changeIndex: (int index) {
            switch (index) {
              case 0:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    isInReceipt = false;
                    tabBody =
                        HomeScreen(animationController: animationController);
                  });
                });
                break;
              case 1:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    isInReceipt = false;
                    tabBody = CalenderScreen(
                        animationController: animationController);
                  });
                });
                break;
              case 2:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    isInReceipt = true;
                    tabBody = ReceiptScreen();
                  });
                });
                break;
              case 3:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    isInReceipt = false;
                    tabBody = ProfileScreen();
                  });
                });
                break;
            }
          },
        ),
      ],
    );
  }
}
