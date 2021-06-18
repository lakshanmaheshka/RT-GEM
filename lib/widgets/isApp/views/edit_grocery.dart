import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/utils/constants_categories.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/widgets/screen_views/form_views/add_grocery_formb.dart';
import 'package:rt_gem/widgets/screen_views/form_views/update_grocery_tab.dart';
import 'package:rt_gem/widgets/responsive.dart';
import 'package:rt_gem/widgets/snackbar.dart';


class EditGrocery extends StatefulWidget {
  @override

  final String currentProductName;
  final String currentCategory;
  final String currentQuantity;
  final String currentItemMfg;
  final String currentItemExp;
  final String documentId;


  const EditGrocery({
    required this.currentProductName,
    required this.currentQuantity,
    required this.currentCategory,
    required this.currentItemMfg,
    required this.currentItemExp,
    required this.documentId,
    Key? key,
  }) : super(key: key);

  _EditGroceryState createState() => _EditGroceryState();
}

class _EditGroceryState extends State<EditGrocery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
      title: Text("Grocery Details"),
    ),
        body:  Container( child: UpdateGroceryForm(
          currentProductName: widget.currentProductName,
          currentCategory: widget.currentCategory,
          currentItemMfg: widget.currentItemMfg,
          currentItemExp: widget.currentItemExp,
          currentQuantity: widget.currentQuantity,
          documentId: widget.documentId,
        ),));
  }
}
