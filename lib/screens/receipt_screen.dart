import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../utils/receipt_models/transaction.dart';
import '../widgets/receipt_widgets/views/trasactions/daily_spendings.dart';
import '../widgets/receipt_widgets/views/trasactions/monthly_spendings.dart';
import '../widgets/receipt_widgets/views/trasactions/yearly_spendings.dart';
import '../widgets/receipt_widgets/widgets/app_drawer.dart';
import '../widgets/receipt_widgets/views/new_transaction.dart';
import '../widgets/receipt_widgets/views/trasactions/weekly_spendings.dart';

class ReceiptScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen>
    with SingleTickerProviderStateMixin {
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
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Receipt Tracker",
          style: Theme.of(context).appBarTheme.textTheme!.headline1,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(NewTransaction.routeName)),
        ],
        bottom: new TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorColor: Theme.of(context).primaryColorDark,
          tabs: <Widget>[
            new Tab(
              text: "Daily",
            ),
            new Tab(
              text: "Weekly",
            ),
            new Tab(
              text: 'Monthly',
            ),
            new Tab(
              text: 'Yearly',
            ),
          ],
          controller: tabController,
        ),
      ),
      body: Center(
        child: Container(
          width: 800,
          child: FutureBuilder(
            future: Provider.of<Transactions>(context, listen: false)
                .fetchTransactions(),
            builder: (ctx, snapshot) =>
                (snapshot.connectionState == ConnectionState.waiting)
                    ? Center(child: CircularProgressIndicator())
                    : TabBarView(
                        children: <Widget>[
                          new DailySpendings(),
                          new WeeklySpendings(),
                          new MonthlySpendings(),
                          new YearlySpendings(),
                        ],
                        controller: tabController,
                      ),
          ),
        ),
      ),
      /*drawer: Consumer<Transactions>(
        builder: (context, trx, child) {
          return AppDrawer(total: trx.getTotal(trx.transactions));
        },
      ),*/
    );
  }
}
