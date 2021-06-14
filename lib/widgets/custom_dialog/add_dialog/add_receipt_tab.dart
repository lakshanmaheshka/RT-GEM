import 'package:flutter/material.dart';
import 'package:rt_gem/budget/screens/new_transaction.dart';
import 'package:rt_gem/widgets/responsive.dart';

class TabTwo extends StatefulWidget {
  const TabTwo({
    Key? key,
  }) :  super(key: key);

  @override
  _TabTwoState createState() => _TabTwoState();
}

class _TabTwoState extends State<TabTwo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child:

                Container(
                  width: Responsive.deviceWidth(65, context),
                  height: Responsive.deviceHeight(7, context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal,
                        Colors.blue,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Center(
                    child: InkWell(
                      onTap:  () =>
                      Navigator.of(context).pushNamed(NewTransaction.routeName),
                      child: Text(
                        'Press',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}