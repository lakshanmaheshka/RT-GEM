import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/pages/main_page.dart';

import 'pages/login_page.dart';
import 'provider/email_sign_in.dart';
import 'provider/google_sign_in.dart';

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
  static final String title = 'RT GEM';

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ChangeNotifierProvider(create: (context) => EmailSignInProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: MainPage(),
    ),
  );
}

//Todo: Implement Splash Screen
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => new _SplashScreenState();
// }
//
//
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override void initState() {
//     super.initState();
//     new Future.delayed( const Duration(seconds: 5), () =>
//         Navigator.pushReplacement( context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Color(0xFFE9E4F0),
//       body: new Center(
//         child: Image.asset("assets/images/loop3s.gif",
//             gaplessPlayback: true,
//             fit: BoxFit.fill
//         ),
//
//       ),
//     );
//   }
// }