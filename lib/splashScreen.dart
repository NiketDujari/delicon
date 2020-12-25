import 'package:delicon_internship/loginPage.dart';
import 'package:delicon_internship/reservationsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => auth.currentUser != null
                      ? ReservationScreen()
                      : LoginPage()),
            ));
    controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller.forward();

    controller.addListener(() {
      setState(() {
        print(controller.value);
      });
    });
  }

  AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Opacity(
          opacity: controller.value,
          child: Hero(
            tag: "logo",
            child: Container(
              child: Image.asset("images/deliconlogo.png"),
              height: 350,
              width: 350,
            ),
          ),
        ),
      ),
    );
  }
}
