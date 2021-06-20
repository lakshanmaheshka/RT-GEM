import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rt_gem/utils/app_theme.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';

import 'package:rt_gem/utils/receipt_models/pie_data.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/statistics/pie_chart.dart';
import 'package:rt_gem/widgets/receipt_widgets/widgets/no_trancaction.dart';
import 'package:rt_gem/widgets/receipt_widgets/widgets/transaction_list_items.dart';
import 'package:rt_gem/widgets/responsive.dart';

class DailySpendings extends StatefulWidget {
  @override
  _DailySpendingsState createState() => _DailySpendingsState();
}

class _DailySpendingsState extends State<DailySpendings> {
  bool _showChart = false;
  late TransactionsProvider trxData;
  Function? deleteFn;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<TransactionsProvider>(context, listen: false);

    deleteFn =
        Provider.of<TransactionsProvider>(context, listen: false).deleteTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final dailyTrans = Provider.of<TransactionsProvider>(context).dailyTransactions();

    final List<PieData> dailyData = PieData().pieChartData(dailyTrans);

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(
                left: 24, right: 24, top: 16, bottom: 18),
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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: [

                            dailyTrans.isEmpty ?
                            Center(
                              child: Text(
                                "No Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: Color(0xff67727d)),
                              ),
                            ) : Center(child: Container(

                                child: MyPieChart(pieData: dailyData)))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),



          Container(
              padding: const EdgeInsets.only(
                  right: 15, top: 10, bottom: 10, left: 15),
              color: Theme.of(context).primaryColorLight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "₹${trxData.getTotal(dailyTrans)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     Text(
                  //       'Show Chart',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //     Switch.adaptive(
                  //       activeColor: Theme.of(context).accentColor,
                  //       value: _showChart,
                  //       onChanged: (val) {
                  //         setState(() {
                  //           _showChart = val;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              )),
       /*   dailyTrans.isEmpty
              ? NoTransactions()
              :  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return TransactionListItems(
                            trx: dailyTrans[index], dltTrxItem: deleteFn);
                      },
                      itemCount: dailyTrans.length,
                    ),*/

          dailyTrans.isEmpty
              ? NoTransactions()
              : StreamBuilder<QuerySnapshot>(
            stream: Database.readReceipts(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                return  ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    var receipts = snapshot.data!.docs[index].data();
                    String docID = snapshot.data!.docs[index].id;
                    String id = receipts['id'];
                    String receiptName = receipts['receiptName'];
                    int amount = receipts['amount'];
                    String expiryDate = receipts['category'];
                    String addedDate = receipts['addedDate'];


                    return TransactionListItems(
                        trx: dailyTrans[index], dltTrxItem: deleteFn, documentId: docID);
                  },
                  itemCount: dailyTrans.length,
                );




                 /* ListView.builder(
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
                    String quantity = groceries['quantity'];

                    return ItemsView(
                        animation: animation,
                        animationController: animationController,
                        productName: productName,

                        docID: docID,
                        currentCategory: category,
                        currentItemMfg: manufactureDate,
                        currentItemExp: expiryDate,
                        currentQuantity: quantity
                    );
                  },
                );*/
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

          kIsWeb ? SizedBox( ) : SizedBox( height: 80),

        ],
      ),
    );
  }
}
