import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/app_theme.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';

import 'package:rt_gem/utils/receipt_models/pie_data.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/statistics/pie_chart.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/statistics/yearly_stats.dart';
import 'package:rt_gem/widgets/receipt_widgets/widgets/no_trancaction.dart';
import 'package:rt_gem/widgets/receipt_widgets/widgets/transaction_list_items.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class YearlySpendings extends StatefulWidget {
  @override
  _YearlySpendingsState createState() => _YearlySpendingsState();
}

class _YearlySpendingsState extends State<YearlySpendings> {
  String _selectedYear = DateFormat('yyyy').format(DateTime.now());
  bool _showChart = false;
  late TransactionsProvider trxData;

  List<PieData>? yearlyData;


  @override
  void initState() {
    super.initState();
    trxData = Provider.of<TransactionsProvider>(context, listen: false);
  }


  @override
  Widget build(BuildContext context) {

    final deleteFn = Provider.of<TransactionsProvider>(context).deleteTransaction;

    final yearlyTrans = Provider.of<TransactionsProvider>(context, listen: false)
        .yearlyTransactions(_selectedYear);

    final List<PieData> yearlyData = PieData().pieChartData(yearlyTrans);

    final List<Map<String, Object>> groupTransFirstSixMonths = trxData
        .firstSixMonthsTransValues(yearlyTrans, int.parse(_selectedYear));
    final List<Map<String, Object>> groupTransLastSixMonths =
        trxData.lastSixMonthsTransValues(yearlyTrans, int.parse(_selectedYear));
    bool checkForEmpty(List<Map<String, Object>> groupTrans) {
      return groupTrans.every((element) {
        if (element['amount'] == 0) {
          return true;
        }
        return false;
      });
    }

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(68.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(68.0),
                    topRight: Radius.circular(8.0)),
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
                      height: (() {
                        if(_showChart){
                          if(checkForEmpty(groupTransFirstSixMonths)){
                            return 350.0;
                          }else if (checkForEmpty(groupTransLastSixMonths)) {
                            return 350.0;
                          } else {
                            return 680.0;
                          }
                        } else {
                          return 250.0;
                        }
                      }()),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            yearlyTrans.isEmpty
                                ? Center(
                                    child: Text(
                                      "No Data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff67727d)),
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                    child: _showChart
                                            ? Column(
                                                children: [
                                                  checkForEmpty(
                                                          groupTransFirstSixMonths)
                                                      ? Container()
                                                      : YearlyStats(
                                                          groupedTransactionValues:
                                                              groupTransFirstSixMonths,
                                                        ),
                                                  checkForEmpty(
                                                          groupTransLastSixMonths)
                                                      ? Container()
                                                      : YearlyStats(
                                                          groupedTransactionValues:
                                                              groupTransLastSixMonths,
                                                        )
                                                ],
                                              )
                                            : MyPieChart(pieData: yearlyData),
                                  ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              padding:
                  const EdgeInsets.only(right: 15, left: 5, top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widgetToSelectYear(),
                      Text(
                        "\$${trxData.getTotal(yearlyTrans)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Show Chart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Switch.adaptive(
                        activeColor: Theme.of(context).accentColor,
                        value: _showChart,
                        onChanged: (val) {
                          setState(() {
                            _showChart = val;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          yearlyTrans.isEmpty
              ? NoTransactions()
              : StreamBuilder<QuerySnapshot>(
                  stream: Database.readReceipts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else if (snapshot.hasData || snapshot.data != null) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,3,20.0,0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            String docID = snapshot.data!.docs[index].id;

                            return TransactionListItems(
                                trx: yearlyTrans[index],
                                dltTrxItem: deleteFn,
                                documentId: docID);
                          },
                          itemCount: yearlyTrans.length,
                        ),
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

          kIsWeb ? SizedBox( ) : SizedBox( height: 80),
        ],
      ),
    );
  }

  Row widgetToSelectYear() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: int.parse(_selectedYear) == 0
              ? null
              : () {
                  setState(() {
                    _selectedYear = (int.parse(_selectedYear) - 1).toString();
                  });
                },
        ),
        Text(_selectedYear),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: _selectedYear == DateFormat('yyyy').format(DateTime.now())
              ? null
              : () {
                  setState(() {
                    _selectedYear = (int.parse(_selectedYear) + 1).toString();
                  });
                },
        ),
      ],
    );
  }

  Column yearlyChart(
    BuildContext context,
    List<PieData> yearlyData,
    List<Map<String, Object>> firstSixMonths,
    List<Map<String, Object>> lastSixMonths,
    Function checkForEmpty,
  ) {
    return Column(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          color: Theme.of(context).primaryColorDark,
          child: MyPieChart(pieData: yearlyData),
        ),
        checkForEmpty(firstSixMonths)
            ? Container()
            : YearlyStats(
                groupedTransactionValues: firstSixMonths,
              ),
        checkForEmpty(lastSixMonths)
            ? Container()
            : YearlyStats(
                groupedTransactionValues: lastSixMonths,
              ),
      ],
    );
  }
}
