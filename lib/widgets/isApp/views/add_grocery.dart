import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_gem/widgets/isApp/scan_provider/scan_provider.dart';
import 'package:rt_gem/widgets/screen_views/form_views/add_grocery_form.dart';


List<CameraDescription> cameras = [];

class AddGrocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) { ScanProvider(); },
      child: Scaffold( appBar: AppBar(
        title: Text("Add Items"),
      ),
          body:  Center(child: Container( width: 800 ,child: AddGroceryForm(),))),
    );
  }
}
