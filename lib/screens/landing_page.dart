import 'package:e_commerce_app/screens/constants.dart';
import 'package:e_commerce_app/screens/home_page.dart';
import 'package:e_commerce_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        // Conection Initialized - Firebase App is running
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamBuilder can check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              // if Stream snapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              // Connection state active - Do the user login check inside the
              // if statement
              if (streamSnapshot.connectionState == ConnectionState.active) {
                // Get the user
                User _user = streamSnapshot.data;

                // if the user is null, we're not loggrd in
                if (_user == null) {
                  // the user is not loggrd in, head to login page
                  return LoginPage();
                } else {
                  // the user is logged in, head to home page
                  return HomePage();
                }
              }

              //Checking the auth state - Loading
              return Scaffold(
                body: Center(
                    child: Text(
                  "Checking Authentication...",
                  style: Constants.regularheading,
                )),
              );
            },
          );
        }

        //Connecting to Firebase - Loading
        return Scaffold(
          body: Center(
              child: Text(
            "initializing App...",
            style: Constants.regularheading,
          )),
        );
      },
    );
  }
}
