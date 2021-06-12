
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/widgets/custom_dialog/add_dialog/add_dialog.dart';
import 'package:rt_gem/widgets/custom_dialog/edit_dialog/edit_dialog.dart';
import 'package:rt_gem/widgets/isApp/models/meals_list_data.dart';
import 'package:rt_gem/widgets/isApp/ui_view/glass_view.dart';

import '../fintness_app_theme.dart';

class GroceryListView extends StatefulWidget {
  const GroceryListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<dynamic>? mainScreenAnimation;

  @override
  _GroceryListViewState createState() => _GroceryListViewState();
}

class _GroceryListViewState extends State<GroceryListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation as Animation<double>,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: Database.readGroceries(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, right: 16, left: 16),
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final int count =
                        snapshot.data!.docs.length > 10 ? 10 : snapshot.data!.docs.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController!.forward();

                        var groceries = snapshot.data!.docs[index].data();
                        String docID = snapshot.data!.docs[index].id;
                        String productName = groceries['productName'];
                        String category = groceries['category'];
                        String manufactureDate = groceries['manufacturedDate'];
                        String expiryDate = groceries['expiryDate'];

                        return ItemsView(
                          animation: animation,
                          animationController: animationController,
                          productName: productName,

                          docID: docID,
                          currentCategory: category,
                          currentItemMfg: manufactureDate,
                          currentItemExp: expiryDate,
                        );
                      },
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    ),
                  );
                },
              ),





            ),
          ),
        );
      },
    );
  }
}

class ItemsView extends StatelessWidget {
  const ItemsView(
      {Key? key,required this.productName,required this.docID, this.animationController, this.animation, required this.currentCategory, required this.currentItemMfg, required this.currentItemExp})
      : super(key: key);

  // final MealsListData? mealsListData;
  final String productName;
  final String currentCategory;
  final String currentItemMfg;
  final String currentItemExp;
  final String docID;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation as Animation<double>,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: InkWell(
                      borderRadius:const BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(54.0),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditDialog(
                                  currentProductName: productName,
                                currentCategory: currentCategory,
                                currentItemMfg: currentItemMfg,
                                currentItemExp: currentItemExp,
                                documentId: docID,

                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor('#FFB295')
                                    .withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                              HexColor('#FA7D82'),
                              HexColor('#FFB295'),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                productName!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        <String>[currentCategory, currentItemMfg, currentItemExp].join('\n'),
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 15,
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child:



                      //Image.asset("assets/images/Beverages.png"),



                      (() {
                        switch(currentCategory) {
                          case "Beverages":
                            Image.asset("assets/images/Beverages.png");

                          break;

                          case "Bread/Bakery": {
                            Image.asset("assets/images/BreadBakery.png");
                          }
                          break;

                          case "Dairy Products": {
                            Image.asset("assets/images/DairyProducts.png");
                          }
                          break;

                          case "Cereals": {
                            Image.asset("assets/images/Cereals.png");
                          }
                          break;

                          case "Canned Foods": {
                            Image.asset("assets/images/CannedFoods.png");
                          }
                          break;

                          case "Frozen Foods": {
                            Image.asset("assets/images/FrozenFoods.png");
                          }
                          break;

                          case 'Snack Foods':
                            //statements;
                            Image.asset("assets/images/SnackFoods.png");

                          break;

                          case "Others": {
                            CircleAvatar(
                              backgroundColor: Colors.brown.shade800,
                              child:  Image.asset("assets/images/Others.jpg"),
                            );
                          }
                          break;


                          default: {
                            //statements;
                            Image.asset("assets/breakfast.png");
                          }

                        }
                      }())





                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
