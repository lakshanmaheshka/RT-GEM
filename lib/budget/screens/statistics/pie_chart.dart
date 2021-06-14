import 'package:rt_gem/budget/models/pie_data.dart';
import 'package:rt_gem/budget/widgets/pie_chart_widgets/indicators_widget.dart';
import 'package:rt_gem/budget/widgets/pie_chart_widgets/pie_chart_sections.dart';
import 'package:rt_gem/budget/widgets/touch_input.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  final List<PieData>? pieData;

  const MyPieChart({
    Key? key,
    this.pieData,
  }) : super(key: key);

  @override
  _MyPieChartState createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final screenWidht = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidht*0.95,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (pieTouchResponse) {
                    setState(() {
                      if (pieTouchResponse.touchInput is FlLongPressEnd ||
                          pieTouchResponse.touchInput is FlPanEnd) {
                        touchedIndex = -1;
                      } else {
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      }
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: getSections(touchedIndex, widget.pieData!,screenWidht),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: IndicatorsWidget(
                  pieData: widget.pieData,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
