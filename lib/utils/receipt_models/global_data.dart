import 'package:flutter/material.dart';

class Globaldata{
  static String? mfdString = "loading";

  static String? expString = "loading";

  //static int? filter;

  static ValueNotifier<int> filter = ValueNotifier<int>(0);

  static ValueNotifier<bool> stateChanged = ValueNotifier<bool>(true);


}