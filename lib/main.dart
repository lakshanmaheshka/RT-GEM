import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/screens/main_page.dart';
import 'package:rt_gem/utils/app_theme.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';

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
  print("object ");
  FirebaseMessaging.instance.getToken().then(print);
}

class MyApp extends StatelessWidget {
  static final String title = 'RT GEM';

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
      ChangeNotifierProvider(create: (context) => EmailSignInProvider()),
      ChangeNotifierProvider(create: (context) => Transactions()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue.withOpacity(0.4),
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.white,
          iconTheme: IconThemeData(color: Colors.blue),
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w700,
              //fontSize: 30,
              letterSpacing: 1.2,
              color: AppTheme.darkerText,
            ),
          ),
        ),
      ),
      home: MainPage(),
    ),
  );
}

// //Todo: Implement Splash Screen
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
//           MaterialPageRoute(builder: (context) => MainPage()),
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Color(0xFFE9E4F0),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               colors: <Color>[
//                 CustomTheme.loginGradientStart,
//                 CustomTheme.loginGradientEnd
//               ],
//               begin: FractionalOffset(0.0, 0.0),
//               end: FractionalOffset(1.0, 1.0),
//               stops: <double>[0.0, 1.0],
//               tileMode: TileMode.clamp),
//         ),
//         child: new Center(
//           child:
//              Image(
//             width:300,
//               height:
//               MediaQuery.of(context).size.height > 800 ? 191.0 : 300,
//               fit: BoxFit.fill,
//               image: const AssetImage('assets/images/splash.gif')),
//
//
//
//         ),
//       ),
//     );
//   }
// }