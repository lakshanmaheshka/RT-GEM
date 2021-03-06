import 'package:rt_gem/screens/login_page.dart';
import 'package:rt_gem/provider/google_sign_in.dart';
import 'package:rt_gem/screens/nav_screen.dart';
import 'package:rt_gem/utils/database.dart';
import 'package:rt_gem/widgets/background_painter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset : false,
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);
            if (provider.isSigningIn!) {
              return buildLoading();
            } else if (snapshot.hasData) {
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User user = auth.currentUser!;
              final uid = user.uid;
              Database.userUid = uid;
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
