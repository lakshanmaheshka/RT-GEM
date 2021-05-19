import 'package:rt_gem/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_gem/screens/crud/login_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logged In',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          if (user.photoURL != null)
            CircleAvatar(
              maxRadius: 25,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
          SizedBox(height: 8),
          if (user.displayName != null)
            Text(
              'Name: ' + user.displayName!,
              style: TextStyle(color: Colors.white),
            ),
          SizedBox(height: 8),
          Text(
            'Email: ' + user.email!,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            child: Text('Logout'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('CRUD'),
          )
        ],
      ),
    );
  }
}
