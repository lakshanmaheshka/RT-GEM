import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/budget/budget.dart';
import 'package:rt_gem/screens/calender_screen.dart';
import 'package:rt_gem/screens/receipt_s.dart';
import 'package:rt_gem/screens/receipt_screen.dart';
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



class _NavScreenState extends State<NavScreen> with TickerProviderStateMixin  {
  AnimationController? animationController;
  final _formKey = GlobalKey<FormState>();
  TabController? _tabController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;


  final List<IconData> _icons = const [
    Icons.home,
    Icons.calendar_today_rounded,
    Icons.receipt,
    Icons.account_box_rounded,
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    _tabController = new TabController(length: 2, vsync: this);

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = HomeScreen(animationController: animationController);
    super.initState();
    firebaseOnMessage();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void firebaseOnMessage(){
    FirebaseMessaging.onMessage.listen((message){
      if (message != null) {
        final title = message.notification!.title;
        final body = message.notification!.body;
        showDialog(context: context, builder: (context){
          return SimpleDialog(
            children: [
              Text('Title: $title'),
              Text('Body: $body')
            ],
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _icons.length,
      child: kIsWeb ? Scaffold(
        appBar: Responsive.isDesktop(context)
            ? PreferredSize(
                preferredSize: Size(screenSize.width, 100.0),
                child: CustomAppBar(
                  //currentUser: currentUser,
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                   onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )
            : null,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog();
                });
          },
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: Responsive.isDesktop(context) ? FloatingActionButtonLocation.centerTop : FloatingActionButtonLocation.endFloat,
        body: AnimatedIndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            HomeScreen(animationController: animationController),
            CalenderScreen(animationController: animationController),
            ReceiptScreen(),
            BudgetApp()
            //ProfileScreen(),
          ],
        ),
        bottomNavigationBar: !Responsive.isDesktop(context)
            ? Container(
                padding: const EdgeInsets.only(bottom: 12.0),
                color: Colors.white,
                child: CustomTabBar(
                  icons: _icons,
                  selectedIndex: _selectedIndex,
                  onTap: (index) => setState(() => _selectedIndex = index),
                ),
              )
            : const SizedBox.shrink(),
      ) : Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
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
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {

            switch (index) {
              case 0:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
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
                    tabBody =
                        CalenderScreen(animationController: animationController);
                  });
                });
                break;
              case 2:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody =
                        ReceiptScreen();
                  });
                });
                break;
              case 3:
                animationController!.reverse().then<dynamic>((data) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    tabBody =
                        BudgetApp();
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



