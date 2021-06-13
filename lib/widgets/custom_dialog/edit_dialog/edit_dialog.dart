import 'package:flutter/material.dart';
import 'package:rt_gem/widgets/custom_dialog/add_dialog/add_grocery_tab.dart';
import 'package:rt_gem/widgets/custom_dialog/add_dialog/add_receipt_tab.dart';
import 'package:rt_gem/widgets/responsive.dart';

import 'update_grocery_tab.dart';

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
  TabController? _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
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
                Material(
                  color: Colors.indigo,
                  child: TabBar(
                    labelColor: Colors.redAccent,
                    unselectedLabelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Update Grocery"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Add Receipt"),
                        ),
                      ),
                    ],
                    controller: _tabController,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UpdateGroceryForm(
                        currentProductName: widget.currentProductName,
                        currentCategory: widget.currentCategory,
                        currentItemMfg: widget.currentItemMfg,
                        currentItemExp: widget.currentItemExp,
                        currentQuantity: widget.currentQuantity,
                        documentId: widget.documentId,
                      ),
                      TabTwo()

                    ],
                    controller: _tabController,
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