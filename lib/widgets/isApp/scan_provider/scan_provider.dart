import 'package:flutter/material.dart';

class ScanProvider extends ChangeNotifier {

  //define your private data field(s). I'm using int here.
  String? _mydata;

  ScanProvider(){
    String? _mydata = "loading";

  }

  //define a getter
  String? get myData => _mydata;

  // define a setter
  set myData(newData){
    _mydata = newData;
    notifyListeners();
  }
}