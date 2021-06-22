import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:intl/intl.dart';
import 'package:rt_gem/utils/receipt_models/global_data.dart';

class ScannedDateDetailsScreen extends StatefulWidget {
  final String imagePath;

  const ScannedDateDetailsScreen({required this.imagePath});

  @override
  _ScannedDateDetailsScreenState createState() => _ScannedDateDetailsScreenState();
}

class _ScannedDateDetailsScreenState extends State<ScannedDateDetailsScreen> {
  late final String _imagePath;
  late final TextDetector _textDetector;
  Size? _imageSize;
  List<TextElement> _elements = [];

  //List<String>? listEmailStrings;

  String recognizedText = "Loading ...";

  //static String expString = "Loading ...";

 // static String mfdString = "Loading ...";


  // Fetching the image size from the image file
  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  // To detect the email addresses present in an image
  void _recognizeEmails() async {
    _getImageSize(File(_imagePath));

    // Creating an InputImage object using the image path
    final inputImage = InputImage.fromFilePath(_imagePath);
    // Retrieving the RecognisedText from the InputImage
    final text = await _textDetector.processImage(inputImage);

    // Pattern of RegExp for matching a general email address
   /* String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
*/
    String pattern =
        r"^[\d]{2}([\W])[\d]{2}([\W])[\d]{4}|^[\d]{4}([\W])[\d]{2}([\W])[\d]{2}";

    RegExp regEx = RegExp(pattern);

    List<String> emailStrings = [];

    // String mailAddress = "";
    // // Finding and storing the text String(s) and the TextElement(s)
    // for (TextBlock block in text.textBlocks) {
    //   for (TextLine line in block.textLines) {
    //     print('text: ${line.lineText}');
    //     if (regEx.hasMatch(line.lineText)) {
    //       emailStrings.add(line.lineText);
    //       for (TextElement element in line.textElements) {
    //         _elements.add(element);
    //       }
    //     }
    //   }
    // }

    String mailAddress = "";
    for (TextBlock block in text.textBlocks) {
      for (TextLine line in block.textLines) {
        if (regEx.hasMatch(line.lineText)) {
          mailAddress += line.lineText + '\n';
          for (TextElement element in line.textElements) {
            _elements.add(element);
          }
        }
      }
    }

    if (this.mounted) {
      setState(() {
        recognizedText = mailAddress;
      });
    }


    //split string

    String newrecognizedText = recognizedText.replaceAll(RegExp(r'\n$'), '');
    var arr = newrecognizedText.split('\n');

   // print(arr);
    List formatdate = [];
    List dateformat = [];

    List ddformatdate= [];
    List yyyyformatdate=[];

    for (var age in arr) {
      final dayFormat = RegExp(r'^[\d]{2}([\W])[\d]{2}([\W])[\d]{4}');
      final yearFormat = RegExp(r'^[\d]{4}([\W])[\d]{2}([\W])[\d]{2}');

      String newdate = age.replaceAll(RegExp(r'\W'), '-');

      if(dayFormat.hasMatch(newdate)){
        ddformatdate.add(newdate);
      }else if(yearFormat.hasMatch(newdate)){
        yyyyformatdate.add(newdate);
      }
      formatdate.add(newdate);
      //print(formatdate);
    }

    final  DateFormat format = new DateFormat("dd-MM-yyyy");

    for (var date in ddformatdate) {
      var dateString = date;
      DateFormat format = new DateFormat("dd-MM-yyyy");
      var foDate = format.parse(dateString);
      //print(foDate);
      dateformat.add(foDate);
    }

    for (var date in yyyyformatdate) {
      var dateString = date;
      DateFormat format = new DateFormat("yyyy-MM-dd");
      var foDate = format.parse(dateString);
      dateformat.add(foDate);
    }

    if (dateformat.length == 2) {
      DateTime mfd;
      DateTime exp;
      if (dateformat[0].isBefore(dateformat[1])) {
        mfd = dateformat[0];
        exp = dateformat[1];
      } else{
        mfd = dateformat[1];
        exp = dateformat[0];
      }


      setState(() {
        Globaldata.mfdString = format.format(mfd);
        Globaldata.expString = format.format(exp);
      });

    }




  }

  @override
  void initState() {

    Globaldata.mfdString = "loading";
    Globaldata.expString = "loading";

    _imagePath = widget.imagePath;
    // Initializing the text detector
    _textDetector = GoogleMlKit.vision.textDetector();
    _recognizeEmails();
    super.initState();
  }

  @override
  void dispose() {
    // Disposing the text detector when not used anymore
    _textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanned Dates"),
      ),
      body: _imageSize != null
          ? Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  color: Colors.black,
                  child: CustomPaint(
                    foregroundPainter: TextDetectorPainter(
                      _imageSize!,
                      _elements,
                    ),
                    child: AspectRatio(
                      aspectRatio: _imageSize!.aspectRatio,
                      child: Image.file(
                        File(_imagePath),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Identified Dates",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            child: SingleChildScrollView(
                              child: Text(
                                recognizedText,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            child: SingleChildScrollView(
                              child: Text(
                                "mfdString  "+ Globaldata.mfdString!,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            child: SingleChildScrollView(
                              child: Text(
                                "expString "+Globaldata.expString!,
                              ),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              child: Text('Dates are correct'),
                              onPressed: () async {
                                int count = 0;
                                Navigator.of(context).popUntil((_) => count++ >= 2);

                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

// Helps in painting the bounding boxes around the recognized
// email addresses in the picture
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextElement container) {
      return Rect.fromLTRB(
        container.rect.left * scaleX,
        container.rect.top * scaleY,
        container.rect.right * scaleX,
        container.rect.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
