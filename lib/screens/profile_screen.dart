import 'package:rt_gem/provider/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
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
          user.photoURL != null ?
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/tab4s.png',
                    image: user.photoURL!),
              ),
            ) : CircleAvatar(
            maxRadius: 25,
            backgroundImage: AssetImage('assets/images/tab4s.png'),
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
        ],
      ),
    );
  }
}
