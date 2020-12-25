import 'package:delicon_internship/loginPage.dart';
import 'package:delicon_internship/reservationsScreen.dart';
import 'package:delicon_internship/screenBackground.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:toast/toast.dart';

bool passShowing = true;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("Press again to exit", context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          gravity: Toast.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: ScaffoldBG(
        bgColor: Color(0xfff05454),
        cardColor: Colors.white,
        cardChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 150,
                  child: Image(
                    image: AssetImage('images/deliconlogo.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 30, right: 30),
              child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (passShowing != true) {
                              passShowing = true;
                            } else {
                              passShowing = false;
                            }
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color:
                              passShowing ? Colors.white38 : Colors.greenAccent,
                        )),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  obscureText: passShowing ? true : false),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              child: GestureDetector(
                onTap: () async {
                  if (email?.isEmpty ?? true) {
                    Toast.show("Enter Email!", context,
                        duration: Toast.LENGTH_LONG,
                        backgroundColor: Colors.black45,
                        gravity: Toast.CENTER);
                  } else if (password?.isEmpty ?? true) {
                    Toast.show("Enter Password!", context,
                        duration: Toast.LENGTH_LONG,
                        backgroundColor: Colors.black45,
                        gravity: Toast.CENTER);
                  } else {
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Toast.show("Welcome!", context,
                            duration: Toast.LENGTH_LONG,
                            backgroundColor: Colors.black45,
                            gravity: Toast.CENTER);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationScreen()),
                        );
                      } else {
                        Toast.show(
                            "Email already exists. Try a different email",
                            context,
                            duration: Toast.LENGTH_LONG,
                            backgroundColor: Colors.black45,
                            gravity: Toast.CENTER);
                      }
                    } catch (e) {
                      Toast.show(
                          "Email already exists.Try a different email", context,
                          duration: Toast.LENGTH_LONG,
                          backgroundColor: Colors.black45,
                          gravity: Toast.CENTER);
                      print(e);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff797a7e),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Click here",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
