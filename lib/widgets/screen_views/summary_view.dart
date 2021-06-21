
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/commons.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'dart:math' as math;

import '../../utils/app_theme.dart';

class Grocery {
  final String? productName;
  final String? quantity;
  final DateTime? expiryDate;
  final DateTime? manufacturedDate;
  final String? category;
  final bool? isConsumed;

  const Grocery(
      {this.productName, this.quantity, this.expiryDate, this.manufacturedDate, this.category, this.isConsumed});

  Map<String, dynamic> toMap(Grocery t) {
    return {
      'productName': t.productName,
      'quantity': t.quantity,
      'expiryDate': t.expiryDate,
      'manufacturedDate': t.manufacturedDate,
      'category': t.category,
      'isConsumed': t.isConsumed,

    };
  }
}


class SummaryView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  const SummaryView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _SummaryViewState createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {


  late String expires ="All";

  late int itemsleft = 0;
  late int itemsused = 0;
  late int itemformonth = 50;


  late double citemleft = 0.0;
  late double citemsused = 25.0;
  late double citemformonth = 50.0;

  int filter = 0;
  List<Grocery> _transactions = [];

  List<Grocery> _transactionsFalse = [];

  List<Grocery> _transactionsWeek = [];

  List<Grocery> _transactionsMonth = [];


  void getProducts () async {
    final fetchedData = await Database.getDataGrocery();
    //var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime date = DateTime.now();

    _transactions = fetchedData
        .map(
          (item) => Grocery(
            productName: item['productName'],
            quantity: item['quantity'],
            category: item['category'],
            manufacturedDate: item['manufacturedDate'].toDate(),
            expiryDate: item['expiryDate'].toDate(),
            isConsumed: item['isConsumed'],
      ),
    )
        .toList();


    print(_transactions);

    _transactions.forEach((element) {
      if(element.isConsumed != null && element.isConsumed == true ){
        _transactionsFalse.add(element);
        print(_transactionsFalse);
      }
    });

    _transactions.forEach((element) {
      DateTime a = element.expiryDate!;


      if((element.expiryDate!.isAfter(findFirstDateOfTheWeek(date)) || element.expiryDate!.isAtSameMomentAs(findFirstDateOfTheWeek(date))  )
          && (element.expiryDate!.isBefore(findLastDateOfTheWeek(date)) || element.expiryDate!.isAtSameMomentAs(findLastDateOfTheWeek(date)) ) ){
        _transactionsWeek.add(element);
        print(_transactionsWeek);
      }
    });


    _transactions.forEach((element) {
      if((element.expiryDate!.isAfter(findFirstDateOfTheWeek(date)) || element.expiryDate!.isAtSameMomentAs(findFirstDateOfTheWeek(date))  )
          && (element.expiryDate!.isBefore(findLastDateOfTheWeek(date)) || element.expiryDate!.isAtSameMomentAs(findLastDateOfTheWeek(date)) ) ){
        _transactionsWeek.add(element);
        print(_transactionsWeek);
      }
    });

    _transactions.forEach((element) {
      if((element.expiryDate!.isAfter(findFirstDateOfTheMonth(date)) || element.expiryDate!.isAtSameMomentAs(findFirstDateOfTheMonth(date))  )
          && (element.expiryDate!.isBefore(findLastDateOfTheMonth(date)) || element.expiryDate!.isAtSameMomentAs(findLastDateOfTheMonth(date)) ) ){
        _transactionsMonth.add(element);
        print(_transactionsMonth);
      }
    });


    print(_transactionsWeek);
    print(_transactionsWeek.length);

    print(_transactionsFalse);
    print(_transactionsFalse.length);

    print(fetchedData.length);
  }



  @override
  void initState() {

    getProducts();
    super.initState();
    //expires = "this week";
    itemsleft = itemformonth - itemsused;
    citemleft = citemformonth - citemsused;
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation as Animation<double>,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: InkWell(
                    onTap: (){
                      setState(() {

                        filter++;

                        if(filter > 3){
                          filter = 0;
                        }


                        switch (filter) {
                          case 0:
                            expires = "All";
                            break;
                          case 1:
                            expires = "This Day";
                            break;
                          case 2:
                            expires = "This Week";
                            break;
                          case 3:
                            expires = "This Month";
                            break;
                          default:
                            expires = "All";
                        }

                      });
                    },
                  child: StreamBuilder<QuerySnapshot>(
                    stream: filter == 0 ?
                    Database.readGroceries() :
                        filter == 1 ?
                        Database.readGroceriesByDay() :
                        filter == 2 ?
                        Database.readGroceriesByWeek() :
                        filter == 3 ?
                        Database.readGroceriesByMonth() :  Database.readGroceries(),

                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          height: 225,
                            child: Text('Something went wrong')
                        );
                      } else if (snapshot.hasData || snapshot.data != null) {

                        // var groceries = snapshot.data!.docs[index].data();
                        // String docID = snapshot.data!.docs[index].id;
                        // String productName = groceries['productName'];
                        // String category = groceries['category'];
                        // String manufactureDate = dateFormatS.format(groceries['manufacturedDate']);
                        // String expiryDate = dateFormatS.format(groceries['expiryDate']);
                        // String quantity = groceries['quantity'];


                        return Column(
                          children: <Widget>[

                            Padding(
                              padding:
                              const EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 48,
                                                width: 2,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#87A0E5')
                                                      .withOpacity(0.5),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 4, bottom: 2),
                                                      child: Text(
                                                        'Items Added',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                          AppTheme.fontName,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 16,
                                                          letterSpacing: -0.1,
                                                          color: AppTheme.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 28,
                                                          height: 28,
                                                          child: Image.asset(
                                                              "assets/images/AddedItems.png"),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              left: 4, bottom: 3),
                                                          child: Text(
                                                            '${(snapshot.data!.docs.length * widget.animation!.value).toInt()}',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily:
                                                              AppTheme
                                                                  .fontName,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 16,
                                                              color: AppTheme
                                                                  .darkerText,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 48,
                                                width: 2,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#F56E98')
                                                      .withOpacity(0.5),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    expires = "today";
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 4, bottom: 2),
                                                        child: Text(
                                                          'Expires $expires',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                            AppTheme.fontName,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: kIsWeb ? 16 : 14,
                                                            letterSpacing: -0.1,
                                                            color: AppTheme.grey
                                                                .withOpacity(0.5),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 28,
                                                            height: 28,
                                                            child: Image.asset(
                                                                "assets/fitness_app/burned.png"),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 4, bottom: 3),
                                                            child: Text(
                                                              '${(5 * widget.animation!.value).toInt()}',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                AppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                fontSize: 16,
                                                                color: AppTheme
                                                                    .darkerText,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Center(
                                      child: Stack(
                                        clipBehavior: Clip.none, children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                color: AppTheme.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0),
                                                ),
                                                border: new Border.all(
                                                    width: 4,
                                                    color: AppTheme
                                                        .nearlyDarkBlue
                                                        .withOpacity(0.2)),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    '${(itemsleft * widget.animation!.value).toInt()}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                      AppTheme.fontName,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 24,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme
                                                          .nearlyDarkBlue,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Items left',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                      AppTheme.fontName,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      letterSpacing: 0.0,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: CustomPaint(
                                              painter: CurvePainter(
                                                  colors: [
                                                    AppTheme.nearlyDarkBlue,
                                                    HexColor("#8A98E8"),
                                                    HexColor("#8A98E8")
                                                  ],
                                                  angle: itemformonth == 0 ?   (0 +
                      (1.0 - widget.animation!.value)) :



                                                  (340/
                                                      itemformonth) * itemsleft+
                                                          (1.0 - widget.animation!.value)),
                                              child: SizedBox(
                                                width: 108,
                                                height: 108,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  expires,

                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily:
                                    AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.1,
                                    color: AppTheme.grey
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 8, bottom: 8),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, top: 8, bottom: 16),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,8,0,8),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                ' \nBeverages',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Container(
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    HexColor('#FA7D82').withOpacity(0.2),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(4.0)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: ((70 / 1.2) * widget.animation!.value),
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(colors: [
                                                            HexColor('#FA7D82'),
                                                            HexColor('#FFB295')
                                                                .withOpacity(0.5),
                                                          ]),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(4.0)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6),
                                                child: Text(
                                                  '12g left',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color:
                                                    AppTheme.grey.withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Bread/\nBakery',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Container(
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    HexColor('#fc4a1a').withOpacity(0.2),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(4.0)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: ((70 / 1.2) * widget.animation!.value),
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(colors: [
                                                            HexColor('#fc4a1a'),
                                                            HexColor('#f7b733')
                                                                .withOpacity(0.5),
                                                          ]),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(4.0)),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6),
                                                child: Text(
                                                  '12g left',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color:
                                                    AppTheme.grey.withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Dairy\nProducts',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  letterSpacing: -0.2,
                                                  color: AppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Container(
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#f7ff00')
                                                        .withOpacity(0.2),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(4.0)),
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: ((70 / 2) *
                                                            widget.animationController!.value),
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                          LinearGradient(colors: [
                                                            HexColor('#f7ff00')
                                                                .withOpacity(0.1),
                                                            HexColor('#db36a4'),
                                                          ]),
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(4.0)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 6),
                                                child: Text(
                                                  '30g left',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: AppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    ' \nCereals',
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                      letterSpacing: -0.2,
                                                      color: AppTheme.darkText,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 0, top: 4),
                                                    child: Container(
                                                      height: 4,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        color: HexColor('#d53369')
                                                            .withOpacity(0.2),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: (((70 /
                                                                citemformonth) * citemleft) *
                                                                widget.animationController!.value),
                                                            height: 4,
                                                            decoration: BoxDecoration(
                                                              gradient:
                                                              LinearGradient(colors: [
                                                                HexColor('#d53369')
                                                                    .withOpacity(0.1),
                                                                HexColor('#cbad6d'),
                                                              ]),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(4.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6),
                                                    child: Text(
                                                      '$citemleft left',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        color: AppTheme.grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Canned\nFoods',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color:
                                                  HexColor('#f857a6').withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: ((70 / 1.2) * widget.animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                          HexColor('#f857a6'),
                                                          HexColor('#ff5858')
                                                              .withOpacity(0.5),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '12g left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.grey.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Frozen\nFoods',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color:
                                                  HexColor('#87A0E5').withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: ((70 / 1.2) * widget.animation!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(colors: [
                                                          HexColor('#2193b0'),
                                                          HexColor('#6dd5ed')
                                                              .withOpacity(0.5),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '12g left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                  AppTheme.grey.withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Snack\nFoods',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                letterSpacing: -0.2,
                                                color: AppTheme.darkText,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#FC5C7D')
                                                      .withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: ((70 / 2) *
                                                          widget.animationController!.value),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                        LinearGradient(colors: [
                                                          HexColor('#FC5C7D')
                                                              .withOpacity(0.1),
                                                          HexColor('#6A82FB'),
                                                        ]),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(4.0)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                '30g left',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: AppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  ' \nOthers',
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    letterSpacing: -0.2,
                                                    color: AppTheme.darkText,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 0, top: 4),
                                                  child: Container(
                                                    height: 4,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      color: HexColor('#11998e')
                                                          .withOpacity(0.2),
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          width: ((70 / 2.5) *
                                                              widget.animationController!.value),
                                                          height: 4,
                                                          decoration: BoxDecoration(
                                                            gradient:
                                                            LinearGradient(colors: [
                                                              HexColor('#11998e')
                                                                  .withOpacity(0.1),
                                                              HexColor('#38ef7d'),
                                                            ]),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(4.0)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6),
                                                  child: Text(
                                                    '10g left',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontName,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: AppTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        );
                      }

                      return Container(
                        height: 225,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CustomColors.firebaseOrange,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color>? colorsList = <Color>[];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList!,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
