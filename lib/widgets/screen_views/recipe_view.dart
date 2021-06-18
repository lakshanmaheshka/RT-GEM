
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rt_gem/utils/receipe_models/recipe_model.dart';
import 'package:rt_gem/widgets/screen_views/recipe_tile.dart';
import 'package:rt_gem/utils/custom_colors.dart';
import 'package:rt_gem/utils/database.dart';
import 'dart:math' as math;

import '../../utils/app_theme.dart';

class RecipeView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation? animation;

  const RecipeView(
      {Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  List<RecipeModel> recipies = [];
  String? ingridients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController();
  late Color randomColorOne;
  late Color randomColorTwo;
  @override
  void initState() {
    super.initState();
    randomColorOne = RandomColor.next();
    randomColorTwo = RandomColor.next();
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
              child: Container(
                decoration: BoxDecoration(
                    gradient :LinearGradient(
                        colors: [
                          randomColorOne,
                          randomColorTwo
                        ],
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      bottomLeft: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                      topRight: Radius.circular(50.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Stack(
                        children: <Widget>[
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: !kIsWeb ? Platform.isIOS? 60: 30 : 30, horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "What will you cook today?",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Overpass'),
                                  ),
                                  Text(
                                    "Just Enter Ingredients you have and we will show the best recipe for you",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'OverpassRegular'),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextField(
                                            controller: textEditingController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'Overpass'),
                                            decoration: InputDecoration(
                                              hintText: "Enter Ingridients",
                                              hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white.withOpacity(0.5),
                                                  fontFamily: 'Overpass'),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              if (textEditingController.text.isNotEmpty) {
                                                setState(() {
                                                  _loading = true;
                                                });
                                                recipies = [];
                                                String url =
                                                    "https://api.edamam.com/search?q=${textEditingController.text}&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                                                var response = await http.get(Uri.parse(url));
                                                print(" $response this is response");
                                                Map<String, dynamic> jsonData =
                                                jsonDecode(response.body);
                                                print("this is json Data $jsonData");
                                                jsonData["hits"].forEach((element) {
                                                  print(element.toString());
                                                  RecipeModel recipeModel = new RecipeModel();
                                                  recipeModel =
                                                      RecipeModel.fromMap(element['recipe']);
                                                  recipies.add(recipeModel);
                                                  print(recipeModel.url);
                                                });
                                                setState(() {
                                                  _loading = false;
                                                });

                                                print("doing it");
                                              } else {
                                                print("not doing it");
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        const Color(0xffA2834D),
                                                        const Color(0xffBC9A5F)
                                                      ],
                                                      begin: FractionalOffset.topRight,
                                                      end: FractionalOffset.bottomLeft)),
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.search,
                                                      size: 18,
                                                      color: Colors.white
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  _loading ?  Container(
                                    height: 225,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          CustomColors.firebaseOrange,
                                        ),
                                      ),
                                    ),
                                  ) : Container(
                                    child: kIsWeb ? Card(
                                      child: GridView(
                                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                              mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics: ClampingScrollPhysics(),
                                          children: List.generate(recipies.length, (index) {
                                            return GridTile(
                                                child: RecipieTile(
                                                  title: recipies[index].label,
                                                  imgUrl: recipies[index].image,
                                                  desc: recipies[index].source,
                                                  url: recipies[index].url,
                                                ));
                                          })),
                                    ) :
                                    ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: ClampingScrollPhysics(),
                                        children: List.generate(recipies.length, (index) {
                                          return Card(
                                            child: GridTile(
                                                child: RecipieTile(
                                                  title: recipies[index].label,
                                                  imgUrl: recipies[index].image,
                                                  desc: recipies[index].source,
                                                  url: recipies[index].url,
                                                )),
                                          );
                                        }))
                                  ),

                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
