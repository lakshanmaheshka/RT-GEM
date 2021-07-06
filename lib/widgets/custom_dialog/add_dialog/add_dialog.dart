import 'package:flutter/material.dart';
import 'package:rt_gem/widgets/screen_views/form_views/add_grocery_form.dart';
import 'package:rt_gem/utils/responsive.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
  }) : super(key: key);


  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> with SingleTickerProviderStateMixin {

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
                     "Add Items",
                     style: TextStyle(
                       fontSize: 24.0,
                       fontWeight: FontWeight.w700,
                     ),
                   ),
                  ),
                ),
                Expanded(
                  child: AddGroceryForm(),
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