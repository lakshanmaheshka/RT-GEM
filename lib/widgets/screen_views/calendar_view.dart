
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rt_gem/utils/commons.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/utils/calendar_utils.dart';
import 'package:rt_gem/utils/grocery_models/grocery_model.dart';
import 'package:rt_gem/utils/receipt_models/global_data.dart';
import 'package:rt_gem/utils/responsive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;

import '../../utils/app_theme.dart';

class CalendarView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;



  const CalendarView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;


  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Map<DateTime, List<Event>> _kEventSource = {};


  getProducts () async {

    List<Grocery> _groceries = [];

    final fetchedData = await Database.getGroceryData();

    _groceries = fetchedData
        .map(
          (item) => Grocery(
        productName: item['productName'],
        quantity: item['quantity'],
        category: item['category'],
        manufacturedDate: item['manufacturedDate'].toDate(),
        expiryDate: item['expiryDate'].toDate(),
        isConsumed: item['isConsumed'],
      ),
    )
        .toList();

    List<Event> event = [];

    _kEventSource = {};

    for (var i = 0; i < _groceries.length; i++) {

      if(_kEventSource.containsKey(_groceries[i].expiryDate!)){

        event = _kEventSource[_groceries[i].expiryDate!]!;
        event.add(
            Event(_groceries[i].productName!, _groceries[i].category!, _groceries[i].isConsumed!, dateFormatS.format(_groceries[i].manufacturedDate!),dateFormatS.format(_groceries[i].expiryDate!))
        );

        _kEventSource.remove(_groceries[i].expiryDate!);

        _kEventSource.putIfAbsent(_groceries[i].expiryDate!, () {
          return event;
        });

        event = [];

      } else {
        event = [Event(_groceries[i].productName!, _groceries[i].category!, _groceries[i].isConsumed!, dateFormatS.format(_groceries[i].manufacturedDate!), dateFormatS.format(_groceries[i].expiryDate!))] ;

        _kEventSource.putIfAbsent(_groceries[i].expiryDate!, () {
          return event;
        });

        event = [];
      }

    }
  }

  List<Event> _getEventsForDay(DateTime day) {

    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);

    return kEvents[day] ?? [];
  }


  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }



  @override
  Widget build(BuildContext context) {
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
              child: ValueListenableBuilder(
                valueListenable: Globaldata.stateChanged,
                builder: (BuildContext context, bool value, Widget? child) {

                  return  FutureBuilder(
                    future: getProducts(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      switch (snapshot.connectionState) {
                        default:
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          else
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        bottomLeft: Radius.circular(30.0),
                                        bottomRight: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: AppTheme.grey.withOpacity(0.2),
                                          offset: Offset(1.1, 1.1),
                                          blurRadius: 10.0),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TableCalendar<Event>(
                                      firstDay: DateTime(1900),
                                      lastDay: DateTime(2100),
                                      focusedDay: _focusedDay,
                                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                      rangeStartDay: _rangeStart,
                                      rangeEndDay: _rangeEnd,
                                      calendarFormat: _calendarFormat,
                                      rangeSelectionMode: _rangeSelectionMode,
                                      eventLoader: _getEventsForDay,
                                      startingDayOfWeek: StartingDayOfWeek.monday,
                                      calendarStyle: CalendarStyle(
                                        outsideDaysVisible: false,
                                      ),
                                      onDaySelected: _onDaySelected,
                                      onRangeSelected: _onRangeSelected,
                                      onFormatChanged: (format) {
                                        if (_calendarFormat != format) {
                                          setState(() {
                                            _calendarFormat = format;
                                          });
                                        }
                                      },
                                      onPageChanged: (focusedDay) {
                                        _focusedDay = focusedDay;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25.0),
                                Container(
                                  height: Responsive.deviceHeight(100, context),
                                  child: ValueListenableBuilder<List<Event>>(
                                    valueListenable: _selectedEvents,
                                    builder: (context, value, _) {


                                      return ListView.builder(
                                        itemCount: value.length,
                                        itemBuilder: (context, index) {

                                          int daysLeft = daysBetween(DateTime.now(), convertToDate(value[index].expriationDate)! );

                                          return Container(
                                            child:  Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 32, left: 8, right: 8, bottom: 16),
                                                  child: Center(
                                                    child: Container(
                                                      width: Responsive.deviceHeight(90, context),
                                                      decoration: BoxDecoration(
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                              color: HexColor('#FFB295')
                                                                  .withOpacity(0.6),
                                                              offset: const Offset(1.1, 4.0),
                                                              blurRadius: 8.0),
                                                        ],
                                                        gradient: LinearGradient(
                                                          colors: getCategoryColor(value[index].category),
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                        borderRadius: const BorderRadius.only(
                                                          bottomRight: Radius.circular(8.0),
                                                          bottomLeft: Radius.circular(8.0),
                                                          topLeft: Radius.circular(8.0),
                                                          topRight: Radius.circular(8.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 30, left: 16, right: 16, bottom: 30),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "Product Name :"+value[index].itemName,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily: AppTheme.fontName,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    letterSpacing: 0.2,
                                                                    color: AppTheme.white,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Manufactured Date :"+value[index].manufactureDate,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily: AppTheme.fontName,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    letterSpacing: 0.2,
                                                                    color: AppTheme.white,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Expiration Date :"+value[index].expriationDate,
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily: AppTheme.fontName,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 16,
                                                                    letterSpacing: 0.2,
                                                                    color: AppTheme.white,
                                                                  ),
                                                                ),

                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(0,8.0,0,0),
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.white.withOpacity(0.6),
                                                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(5.0),
                                                                      child: Text(
                                                                          daysLeft <= 7  && daysLeft >= 2 ? "Expires Soon !!" :  daysLeft <= 1  && daysLeft >= 0 ? "Expires Today !!" :  daysLeft < 0 ? "Expired !! " : "Days Left : "+daysLeft.toString(),
                                                                          style: TextStyle(
                                                                            fontFamily: AppTheme.fontName,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 18,
                                                                            letterSpacing: 0.2,
                                                                            color: daysLeft < 0 ? Colors.red : Colors.blueAccent,
                                                                          )
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    width: 84,
                                                    height: 84,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.nearlyWhite.withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  left: 15,
                                                  child: getCategoryImage(value[index].category),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Container(
                                                    width: 74,
                                                    height: 74,
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.nearlyWhite.withOpacity(0.2),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),

                                                value[index].isUsed ?

                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child:SizedBox(
                                                      width: 60,
                                                      height: 60,
                                                      child: Image.asset("assets/images/checked.png")),
                                                ) : Container()

                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
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
      ..strokeCap = StrokeCap.round
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
