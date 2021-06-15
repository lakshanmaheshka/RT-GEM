import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rt_gem/utils/app_theme.dart';

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
  late Transactions trxData;
  Function? deleteFn;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<Transactions>(context, listen: false);

    deleteFn =
        Provider.of<Transactions>(context, listen: false).deleteTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final dailyTrans = Provider.of<Transactions>(context).dailyTransactions();

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
          dailyTrans.isEmpty
              ? NoTransactions()
              :  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return TransactionListItems(
                            trx: dailyTrans[index], dltTrxItem: deleteFn);
                      },
                      itemCount: dailyTrans.length,
                    )
        ],
      ),
    );
  }
}
