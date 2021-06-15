
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/budget/models/pie_data.dart';
import 'package:rt_gem/budget/models/transaction.dart';
import 'package:rt_gem/budget/screens/statistics/pie_chart.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'dart:math' as math;

import '../../utils/app_theme.dart';

class ReceiptGraphView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  const ReceiptGraphView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _ReceiptGraphViewState createState() => _ReceiptGraphViewState();
}

class _ReceiptGraphViewState extends State<ReceiptGraphView> {

  bool _showChart = false;
  late Transactions trxData;
  Function? deleteFn;

  @override
  void initState() {
    super.initState();
    trxData = Provider.of<Transactions>(context, listen: false);

    deleteFn =
        Provider.of<Transactions>(context, listen: false).deleteTransaction;
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final dailyTrans = Provider.of<Transactions>(context).dailyTransactions();

    final List<PieData> dailyData = PieData().pieChartData(dailyTrans);


    return ChangeNotifierProvider(
        create: (context) => Transactions(),
        builder: (context, child) {
          return AnimatedBuilder(
            animation: widget.animationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.animation as Animation<double>,
                child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.animation!.value), 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(68.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: AppTheme.grey.withOpacity(0.2),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Database.readGroceries(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container(
                                height: 225,
                                child: Text('Something went wrong')
                            );
                          } else if (snapshot.hasData || snapshot.data != null) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Container(
                                    width: double.infinity,
                                    height: 250,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Stack(
                                        children: [
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //     top: 10,
                                          //   ),
                                          //   child: Column(
                                          //     crossAxisAlignment: CrossAxisAlignment.start,
                                          //     children: [
                                          //       Text(
                                          //         "Net balance",
                                          //         style: TextStyle(
                                          //             fontWeight: FontWeight.w500,
                                          //             fontSize: 13,
                                          //             color: Color(0xff67727d)),
                                          //       ),
                                          //       SizedBox(
                                          //         height: 10,
                                          //       ),
                                          //       Text(
                                          //         "\$2446.90",
                                          //         style: TextStyle(
                                          //           fontWeight: FontWeight.bold,
                                          //           fontSize: 25,
                                          //         ),
                                          //       )
                                          //     ],
                                          //   ),
                                          // ),
                                          // Positioned(
                                          //   bottom: 0,
                                          //   child: Container(
                                          //     width: (size.width - 20),
                                          //     height: 150,
                                          //
                                          //   ),
                                          // )

                                          dailyTrans.isEmpty ?
                                          Text(
                                            "Net balance",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Color(0xff67727d)),
                                          ) : Text(
                                            "Not",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Color(0xff67727d)),
                                          ),

                                          MyPieChart(pieData: dailyData)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return Container(
                            height: 225,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomColors.firebaseOrange,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color>? colorsList = <Color>[];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList!,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
