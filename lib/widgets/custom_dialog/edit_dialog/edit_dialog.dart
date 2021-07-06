import 'package:flutter/material.dart';
import 'package:rt_gem/utils/responsive.dart';

import '../../screen_views/form_views/update_grocery_form.dart';

class EditDialog extends StatefulWidget {
  final String currentProductName;
  final String currentCategory;
  final String currentQuantity;
  final String currentItemMfg;
  final String currentItemExp;
  final String documentId;


  const EditDialog({
    required this.currentProductName,
    required this.currentQuantity,
    required this.currentCategory,
    required this.currentItemMfg,
    required this.currentItemExp,
    required this.documentId,
    Key? key,
  }) : super(key: key);


  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: Responsive.deviceHeight(60, context),
        width: 350,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: UpdateGroceryForm(
                    currentProductName: widget.currentProductName,
                    currentCategory: widget.currentCategory,
                    currentItemMfg: widget.currentItemMfg,
                    currentItemExp: widget.currentItemExp,
                    currentQuantity: widget.currentQuantity,
                    documentId: widget.documentId,
                  ),
                ),
              ],
            ),
            Positioned(
              right: -15.0,
              top: -20.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}