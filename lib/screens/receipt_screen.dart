import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/utils/app_theme.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/trasactions/daily_spendings.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/trasactions/monthly_spendings.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/trasactions/weekly_spendings.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/trasactions/yearly_spendings.dart';


class ReceiptScreen extends StatefulWidget {
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        title: Text(
          "Receipt Tracker",
          style: const TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: 1.2,
            color: AppTheme.darkerText,
          ),
        ),
        bottom: new TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorColor: Theme.of(context).primaryColorDark,
          tabs: <Widget>[
            new Tab(
              text: "Weekly",
            ),
            new Tab(
              text: 'Monthly',
            ),
            new Tab(
              text: 'Yearly',
            ),
            new Tab(
              text: "Daily",
            ),
          ],
          controller: tabController,
        ),
      ),
      body: Center(
        child: Container(
          width: 800,
          child: FutureBuilder(
            future: Provider.of<TransactionsProvider>(context, listen: false)
                .fetchTransactions(),
            builder: (ctx, snapshot) =>
            (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
              children: <Widget>[
                new WeeklySpendings(),
                new MonthlySpendings(),
                new YearlySpendings(),
                new DailySpendings(),
              ],
              controller: tabController,
            ),
          ),
        ),
      ),
    );
  }
}
