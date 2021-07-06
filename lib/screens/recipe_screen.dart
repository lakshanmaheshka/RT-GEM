import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeScreen extends StatefulWidget {
  final String? postUrl;
  RecipeScreen({required this.postUrl});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  String? finalUrl ;

  @override
  void initState() {
    super.initState();
    finalUrl = widget.postUrl;
    if(widget.postUrl!.contains('http://')){
      finalUrl = widget.postUrl!.replaceAll("http://","https://");
      print(finalUrl! + "this is final url");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: Platform.isIOS? 60: 30, right: 24,left: 24,bottom: 10),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color(0xff213A50),
                      const Color(0xff071930)
                    ],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
            child:  Row(
              mainAxisAlignment: kIsWeb
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "RT GEM",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Overpass'),
                ),
                Text(
                  "Recipes",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      fontFamily: 'Overpass'),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - (Platform.isIOS ? 104 : 60),
              width: MediaQuery.of(context).size.width,
              child: WebView(
                onPageFinished: (val){
                  print(val);
                },
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: finalUrl,
                onWebViewCreated: (WebViewController webViewController){
                  setState(() {
                    _controller.complete(webViewController);
                  });
                },
              ),
            ),
          ),
        ],
      )
    );
  }
}
