import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/utils/constants_categories.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';
import 'package:rt_gem/widgets/isApp/scan_provider/scan_provider.dart';
import 'package:rt_gem/widgets/screen_views/form_views/add_grocery_formb.dart';
import 'package:rt_gem/widgets/responsive.dart';
import 'package:rt_gem/widgets/snackbar.dart';

import 'scan_date_camera_screen.dart';

List<CameraDescription> cameras = [];





class AddGrocery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) { ScanProvider(); },
      child: Scaffold( appBar: AppBar(
        title: Text("Add Grocery"),
      ),
          body:  Container( child: Column(
            children: [
           /*   Center(
                child: ElevatedButton(
                  child: Text('Open route'),
                  onPressed: () async {


                    try {
                      WidgetsFlutterBinding.ensureInitialized();
                      cameras = await availableCameras();
                    } on CameraException catch (e) {
                      print(e);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );

                  },
                ),
              ),*/
              AddGroceryForm(),
            ],
          ),)),
    );
  }
}
