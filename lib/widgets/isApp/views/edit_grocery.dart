import 'package:flutter/material.dart';
import 'package:rt_gem/widgets/screen_views/form_views/update_grocery_form.dart';

class EditGrocery extends StatefulWidget {

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
