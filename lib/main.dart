import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/screens/main_page.dart';
import 'package:rt_gem/utils/app_theme.dart';
import 'package:rt_gem/utils/receipt_models/transaction.dart';

import 'provider/email_sign_in.dart';
import 'provider/google_sign_in.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ChangeNotifierProvider(create: (context) => TransactionsProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blue.shade800,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.white,
          iconTheme: IconThemeData(color: Colors.blue),
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppTheme.darkerText,
            ),
          ),
        ),
      ),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('en', 'GB'),
      ],
      home: MainPage(),
    ),
  );
}