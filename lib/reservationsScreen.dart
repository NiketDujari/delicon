import 'package:delicon_internship/editReservation.dart';
import 'package:delicon_internship/loginPage.dart';
import 'package:delicon_internship/newReservation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final ref = FirebaseDatabase.instance.reference();
  final auth = FirebaseAuth.instance;

  Widget buildReservationsList({Map reservations, String key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Text(
                          "Name:       ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(reservations["customerName"])
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Text(
                          "Mobile:     ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(reservations["customerMobile"])
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Text(
                          "Email ID:   ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(reservations["customerEmail"])
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Date:         ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(reservations["date"])
                          ],
                        ),
                        SizedBox(width: 20),
                        Row(
                          children: [
                            Text(
                              "Time:  ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(reservations["time"])
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(
                                  'Are you sure you want to delete this reservation?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No, cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Yes, delete'),
                                  onPressed: () {
                                    ref
                                        .child("Reservations")
                                        .child(key)
                                        .remove();
                                    Toast.show("Successfully deleted!", context,
                                        duration: Toast.LENGTH_LONG,
                                        backgroundColor: Colors.black45,
                                        gravity: Toast.CENTER);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditReservation(
                                reservations["customerName"],
                                reservations["customerMobile"],
                                reservations["customerEmail"],
                                reservations["date"],
                                reservations["time"],
                                key)),
                      );
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        width: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: Container(),
        actions: [
          Center(
              child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Are you sure you wanna logout?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            auth.signOut();
                            Toast.show("Logged out successfully!", context,
                                duration: Toast.LENGTH_LONG,
                                backgroundColor: Colors.black45,
                                gravity: Toast.CENTER);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Text(
              "Log out",
              style: TextStyle(fontSize: 17),
            ),
          ))
        ],
        title: Text("Reservations"),
      ),
      bottomNavigationBar: new Stack(
        overflow: Overflow.visible,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewReservation()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13), color: Colors.red),
                height: 70.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Text(
                      "Create new Reservation",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: "RedRose"),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        reverse: false,
        scrollDirection: Axis.vertical,
        query: ref.child("Reservations"),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map reservation = snapshot.value;
          String keyz = snapshot.key;
          return buildReservationsList(reservations: reservation, key: keyz);
        },
      ),
    );
  }
}
