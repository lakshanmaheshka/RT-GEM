import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/utils/constants_categories.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/widgets/custom_dialog/add_dialog/add_grocery_tab.dart';
import 'package:rt_gem/widgets/responsive.dart';
import 'package:rt_gem/widgets/snackbar.dart';


class AddGrocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text("Add Grocery"),
    ),
        body:  Container( child: AddGroceryTab(),));
  }
}
