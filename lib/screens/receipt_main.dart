import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/screens/receipt_screen.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/utils/app_theme.dart';
import 'package:rt_gem/widgets/custom_dialog/add_dialog/add_dialog.dart';
import 'package:rt_gem/widgets/receipt_widgets/views/new_transaction.dart';


class ReceiptMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RT GEM',
      theme: ThemeData(
        primaryColor: AppTheme.white,
        accentColor: AppTheme.white.withOpacity(0.4),
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline1: const TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: 1.2,
              color: AppTheme.darkerText,
            ),
          ),
        ),
      ),
      home: ReceiptScreen(),
      // routes: {
      //   ReceiptScreen.routeName: (_) => ReceiptScreen(),
      //   //NewTransaction.routeName: (_) => NewTransaction(),
      // },
    );
  }
}
