import 'package:rt_gem/screens/login_page.dart';
import 'package:rt_gem/provider/google_sign_in.dart';
import 'package:rt_gem/screens/nav_screen.dart';
import 'package:rt_gem/widgets/background_painter.dart';
import 'package:rt_gem/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);

            if (provider.isSigningIn!) {
              return buildLoading();
            } else if (snapshot.hasData) {
              return NavScreen();
            } else {
              return LoginPage();
            }
          },
        ),
      );

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}
