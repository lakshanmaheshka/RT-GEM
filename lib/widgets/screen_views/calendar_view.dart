
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/utils/calendar_utils.dart';
import 'package:rt_gem/utils/grocery_models/grocery_model.dart';
import 'package:rt_gem/utils/receipt_models/global_data.dart';
import 'package:rt_gem/utils/responsive.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;

import '../../utils/app_theme.dart';
import 'grocery_list_view.dart';

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
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  // var _kEventSource = {
  //   DateTime.now(): [Event("1","Others",false,"1")],
  //   DateTime.now(): [Event("2","Others",true,"1")],
  // };

  // final kEvents = LinkedHashMap<DateTime, List<Event>>(
  //   equals: isSameDay,
  //   hashCode: getHashCode,
  // )..addAll(_kEventSource);




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
    final _selectedDay1 = DateTime.now();



    List<Grocery> _groceries = [];


    final fetchedData = await Database.getDataGrocery();
    //var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime date = DateTime.now();

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

    //fetchedData.map((item) => _kEventSource[item['expiryDate'].toDate()] = [Event(item['productName'].toString(), item['category'].toString(), item['isConsumed'], item['productName'].toString())] );
    // _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    //     key: (item) => DateTime.utc(2020, 10, item * 5),
    //     value: (item) => List.generate(
    //         item % 4 + 1, (index) => Event('Event $item | ${index + 1}',"Others",false,"1")))
    //   ..addAll({
    //     DateTime.now(): [
    //       Event("1","Others",false,"1"),
    //       Event("2","Others",false,"1"),
    //     ],
    //   });

    List<Event> event = [];
    //
    // List<DateTime> datee = [];

    _kEventSource = {};

    for (var i = 0; i < _groceries.length; i++) {

      if(_kEventSource.containsKey(_groceries[i].expiryDate!)){

        event = _kEventSource[_groceries[i].expiryDate!]!;
        event.add(
            Event(_groceries[i].productName!, _groceries[i].category!, _groceries[i].isConsumed!, _groceries[i].expiryDate!.toString())
        );

        _kEventSource.remove(_groceries[i].expiryDate!);

        _kEventSource.putIfAbsent(_groceries[i].expiryDate!, () {
          return event;
        });

        event = [];




      } else {
        event = [Event(_groceries[i].productName!, _groceries[i].category!, _groceries[i].isConsumed!, _groceries[i].expiryDate!.toString())] ;

        _kEventSource.putIfAbsent(_groceries[i].expiryDate!, () {
          return event;
        });

        event = [];
      }



    }
    //
    //   datee.add(_groceries[i].expiryDate!);
    //
    //   for (var i = 0; i < datee.length; i++){
    //    
    //   }
    //
    //
    //
    //   _kEventSource[_groceries[i].expiryDate!] = [Event(element.productName!, element.category!, element.isConsumed!, element.expiryDate!.toString())];
    // // }
    //
    // _groceries.forEach((element) {
    //
    //
    //
    //
    //   _kEventSource.putIfAbsent(element.expiryDate!, () {
    //     event.add(Event(element.productName!, element.category!, element.isConsumed!, element.expiryDate!.toString()));
    //
    //     return event;
    //   }
    //   );
    //  // _kEventSource[element.expiryDate!] = [Event(element.productName!, element.category!, element.isConsumed!, element.expiryDate!.toString())];
    //
    // });

    // _getEventsForDay(date);



    //
    // _kEventSource = {
    //   _selectedDay1: [Event('Today\'s Event 1', 'even 2'),],
    //   _selectedDay1.add(Duration(days: 3)): [Event('Today\'s Event 1', 'even 2')],
    // };
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example

    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);

    //print(kEvents);
    return kEvents[day] ?? [];
  }


  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
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
        _rangeStart = null; // Important to clean those
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

    // `start` or `end` could be null
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
                                        topLeft: Radius.circular(18.0),
                                        bottomLeft: Radius.circular(18.0),
                                        bottomRight: Radius.circular(18.0),
                                        topRight: Radius.circular(18.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: AppTheme.grey.withOpacity(0.2),
                                          offset: Offset(1.1, 1.1),
                                          blurRadius: 10.0),
                                    ],
                                  ),
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
                                      // Use `CalendarStyle` to customize the UI
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
                                const SizedBox(height: 8.0),
                                Container(
                                  height: Responsive.deviceHeight(100, context),
                                  child: ValueListenableBuilder<List<Event>>(
                                    valueListenable: _selectedEvents,
                                    builder: (context, value, _) {
                                      return ListView.builder(
                                        itemCount: value.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            // margin: const EdgeInsets.symmetric(
                                            //   horizontal: 12.0,
                                            //   vertical: 4.0,
                                            // ),
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(),
                                            //   borderRadius: BorderRadius.circular(12.0),
                                            // ),
                                            child:  Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 32, left: 8, right: 8, bottom: 16),
                                                  child: Container(
                                                    width: Responsive.deviceHeight(60, context),
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
                                                                value[index].itemName,
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
                                                                value[index].expriationDate,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  fontFamily: AppTheme.fontName,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16,
                                                                  letterSpacing: 0.2,
                                                                  color: AppTheme.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
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





                                            // ListTile(
                                            //   onTap: () => print('${value[index]}'),
                                            //   title: Text('${value[index].itemName}'),
                                            //   subtitle: Text('${value[index].expriationDate}'),
                                            // ),
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
