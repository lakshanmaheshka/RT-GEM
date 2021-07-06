
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/commons.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/utils/receipt_models/global_data.dart';
import 'package:rt_gem/utils/responsive.dart';
import 'package:rt_gem/widgets/custom_dialog/edit_dialog/edit_dialog.dart';
import 'package:rt_gem/widgets/isApp/views/edit_grocery.dart';
import '../../utils/app_theme.dart';

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
            child: ValueListenableBuilder(
              valueListenable: Globaldata.filter,
              builder: (BuildContext context, int value, Widget? child) {
                return Container(
                  height: 216,
                  width: double.infinity,
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                    Globaldata.filter.value == 0 ?
                    Database.readGroceriesByDay() :
                    Globaldata.filter.value == 1 ?
                    Database.readGroceriesByNextDay() :
                    Globaldata.filter.value == 2 ?
                    Database.readGroceriesByWeek() :
                    Globaldata.filter.value == 3 ?
                    Database.readGroceriesByMonth() :
                    Globaldata.filter.value == 4 ?
                    Database.readGroceries() :  Database.readGroceriesByDay(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
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
                            String manufactureDate = dateFormatS.format(groceries['manufacturedDate'].toDate());
                            String expiryDate = dateFormatS.format(groceries['expiryDate'].toDate());
                            String quantity = groceries['quantity'].toString();

                            int daysLeft = daysBetween(DateTime.now(), groceries['expiryDate'].toDate());


                            return ItemsView(
                                animation: animation,
                                animationController: animationController,
                                productName: productName,

                                docID: docID,
                                currentCategory: category,
                                currentItemMfg: manufactureDate,
                                currentItemExp: expiryDate,
                                currentQuantity: quantity,
                                daysLeft: daysLeft
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}


class ItemsView extends StatelessWidget {
  const ItemsView(
      {Key? key,required this.productName,required this.docID, this.animationController, this.animation, required this.currentCategory, required this.currentItemMfg, required this.currentItemExp, required this.currentQuantity, required this.daysLeft})
      : super(key: key);

  final String productName;
  final String currentCategory;
  final String currentItemMfg;
  final String currentItemExp;
  final String currentQuantity;
  final String docID;
  final int daysLeft;
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

                        kIsWeb && Responsive.isDesktop(context) ?
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditDialog(
                                currentProductName: productName,
                                currentCategory: currentCategory,
                                currentItemMfg: currentItemMfg,
                                currentItemExp: currentItemExp,
                                currentQuantity: currentQuantity,
                                documentId: docID,
                              );
                            }) :
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditGrocery(
                              currentProductName: productName,
                              currentCategory: currentCategory,
                              currentItemMfg: currentItemMfg,
                              currentItemExp: currentItemExp,
                              currentQuantity: currentQuantity,
                              documentId: docID,

                            )));
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
                            colors: getCategoryColor(currentCategory),
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
                                productName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: AppTheme.white,
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
                                        <String>[currentCategory, "MFG :"+currentItemMfg, "EXP  :"+currentItemExp, "QTY :"+currentQuantity].join('\n'),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                             Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                      daysLeft <= 7  && daysLeft >= 2 ? "Expires Soon!" :  daysLeft <= 1  && daysLeft >= 0 ? "Expires Today!" :  daysLeft < 0 ? "Expired! " : "Days Left : "+daysLeft.toString(),
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: daysLeft < 0 ? Colors.red : Colors.blueAccent,
                                      )
                                  ),
                                ),
                              )
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
                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 15,
                    child: getCategoryImage(currentCategory),
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
