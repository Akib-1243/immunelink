
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immunelink/screens/homePage.dart';
import 'package:immunelink/screens/signin_screen.dart';

class Wrapper extends StatefulWidget{
  const Wrapper({super.key});

  @override
  State<StatefulWidget> createState() => _WrapperState();

}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return homePage();
            }
            else {
              return SignInScreen();;
            }
          }),
    );
  }
  }