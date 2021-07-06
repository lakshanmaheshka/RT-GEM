import 'package:flutter/material.dart';

import 'package:random_color/random_color.dart';

import 'package:rt_gem/utils/receipt_models/transaction.dart';

class PieData {
  final String? name;
  final double? percent;
  final Color? color;
  final int? price;

  const PieData({
    this.name,
    this.percent,
    this.color,
    this.price,
  });

  List<PieData> pieChartData(List<Receipt> trx) {
    int total = TransactionsProvider().getTotal(trx);
    List<Map<String, Object?>> finalData = sortedPieData(trx);
    RandomColor _randomColor = RandomColor();

    List<PieData> data = [];

    finalData.forEach((element) {
      Color _color =
          _randomColor.randomColor(colorBrightness: ColorBrightness.primary);
      data.add(
        PieData(
          name: element['title'] as String?,
          percent: (((element['amount'] as int) * 100) / total)
              .round()
              .ceilToDouble(),
          color: _color,
          price: element['amount'] as int?,
        ),
      );
    });

    return data;
  }

  // Sortig Data According To Category vise
  List<Map<String, Object?>> sortedPieData(List<Receipt> trx) {
    List<Map<String, Object?>> finalList = [];

    for (var i = 0; i < trx.length; i++) {
      var index = finalList
          .indexWhere((element) => element['title'] == trx[i].category);

      if (index != -1) {
        finalList[index]['amount'] =
            (finalList[index]['amount'] as int) + trx[i].amount!;
      } else {
        finalList.add({
          'title': trx[i].category,
          'amount': trx[i].amount,
        });
      }
    }
    return finalList;
  }
}
