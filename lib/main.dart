import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'pages/login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(<DeviceOrientation>[
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Firebase Setup';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    //title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SplashScreen(),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
  @override void initState() {
    super.initState();
    new Future.delayed( const Duration(seconds: 5), () =>
        Navigator.pushReplacement( context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFE9E4F0),
      body: new Center(
        child: Image.asset("assets/images/loop3s.gif",
            gaplessPlayback: true,
            fit: BoxFit.fill
        ),

      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.indigoAccent.withOpacity(0.2),
    appBar: AppBar(
      title: Text(MyApp.title),
      centerTitle: true,
    ),
    body: Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 36,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Android\n',
                    style: TextStyle(
                      color: Colors.lightGreenAccent.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                      height: 3,
                    ),
                  ),
                  TextSpan(
                    text: 'Firebase Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}