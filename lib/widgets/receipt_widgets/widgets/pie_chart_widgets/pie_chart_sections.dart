import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rt_gem/utils/receipt_models/pie_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

String getCurrency() {
  var format = NumberFormat.simpleCurrency(locale: Platform.localeName);
  return format.currencySymbol;
}

List<PieChartSectionData> getSections(
        int? touchedIndex, List<PieData> pieData , double screenWidth) =>
    pieData
        .asMap()
        .map<int, PieChartSectionData>((index, data) {
          final isTouched = index == touchedIndex;
          final double fontSize = isTouched ? 25 : 16;
          final double radius = isTouched ? screenWidth*0.32 : screenWidth*0.30;
          final String title = isTouched ?  kIsWeb ? '\$.${data.price}' : '${data.name}\n${getCurrency()}.${data.price}' :   '${data.percent}%' ;
          final value = PieChartSectionData(
            color: data.color,
            value: data.percent,
            title: title,
            radius: radius,
            titleStyle: kIsWeb ?
            isTouched ? TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = Colors.black,
            )
               : TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),

            )
            :
            TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
                shadows: [
                  Shadow( // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: Colors.blue
                  ),
                  Shadow( // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: Colors.blue
                  ),
                  Shadow( // topRight
                      offset: Offset(1.5, 1.5),
                      color: Colors.blue
                  ),
                  Shadow( // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: Colors.blue
                  ),
                ]
            )
          );

          return MapEntry(index, value);
        })
        .values
        .toList();
