import 'package:delicon_internship/reservationsScreen.dart';
import 'package:delicon_internship/resgistrationScreen.dart';
import 'package:delicon_internship/screenBackground.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:google_sign_in/google_sign_in.dart';

final passwordHolder = TextEditingController();
final emailHolder = TextEditingController();
bool passShowing = true;

class LoginPage extends StatefulWidget {
  static const String id = 'loginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return '$user';
    }

    return null;
  }

  void signOutGoogle() async {}

  Future<dynamic> getUser() async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        emailHolder.clear();
        passwordHolder.clear();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReservationScreen()),
        );
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Toast.show("Invalid login details!", context,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Colors.black45,
          gravity: Toast.CENTER);
      print(e);
    }
  }

  @override
  void initState() {
    emailHolder.clear();
    passwordHolder.clear();
    super.initState();
  }

  @override
  void dispose() {
    emailHolder.clear();
    passwordHolder.clear();
    super.dispose();
  }

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

  final passwordHolder = TextEditingController();
  final emailHolder = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: ScaffoldBG(
          bgColor: Color(0xffeeeded),
          cardColor: Colors.white,
          cardChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 100,
                      child: Image(
                        image: AssetImage('images/deliconlogo.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: emailHolder,
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
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 30, right: 30),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: passwordHolder,
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
                            color: passShowing
                                ? Colors.white38
                                : Colors.greenAccent,
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
                    obscureText: passShowing ? true : false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: GestureDetector(
                    onTap: () {
                      if (email?.isEmpty ?? true) {
                        Toast.show("Enter Email!", context,
                            duration: Toast.LENGTH_LONG,
                            backgroundColor: Colors.white30,
                            gravity: Toast.CENTER);
                      } else if (password?.isEmpty ?? true) {
                        Toast.show("Enter Password!", context,
                            duration: Toast.LENGTH_LONG,
                            backgroundColor: Colors.white30,
                            gravity: Toast.CENTER);
                      } else {
                        getUser();
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
                          'Login',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Do not have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                          );
                        },
                        child: Text(
                          "Click here",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () {
                      signInWithGoogle().then((result) {
                        if (result != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ReservationScreen();
                              },
                            ),
                          );
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              image: AssetImage("images/glogo.png"),
                              height: 15.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ])),
    );
  }
}
