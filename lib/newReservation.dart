import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:toast/toast.dart';

class NewReservation extends StatefulWidget {
  @override
  _NewReservationState createState() => _NewReservationState();
}

class _NewReservationState extends State<NewReservation> {
  DateTime dateTime;
  String formattedDate;
  TimeOfDay selectedTime;
  String name;
  String mobile;
  String email;
  final ref = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          "New Reservation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                        decoration:
                            const InputDecoration(labelText: "Customer Name"),
                        autocorrect: false,
                        onChanged: (String selectname) {
                          name = selectname;
                          setState(() {
                            print(name);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(labelText: "Mobile Number"),
                        autocorrect: false,
                        onChanged: (String number) {
                          mobile = number;
                          setState(() {
                            print(mobile);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                        decoration:
                            const InputDecoration(labelText: "Email ID"),
                        autocorrect: false,
                        onChanged: (String enteremail) {
                          email = enteremail;
                          setState(() {
                            print(email);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text("    Date:  "),
                        Container(
                          width: 90,
                          child: Text(formattedDate == null
                              ? "        "
                              : formattedDate),
                        ),
                        GestureDetector(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2030))
                                  .then((date) {
                                setState(() {
                                  dateTime = date;
                                  formattedDate = DateFormat('dd-MM-yyyy')
                                      .format(dateTime)
                                      .toString();
                                });
                              });
                            },
                            child: Icon(Icons.calendar_today)),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Time:  "),
                        Container(
                          width: 50,
                          child: Text(selectedTime != null
                              ? selectedTime.toString().substring(
                                  10, selectedTime.toString().length - 1)
                              : ""),
                        ),
                        GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((time) {
                                setState(() {
                                  selectedTime = time;
                                  print(selectedTime);
                                });
                              });
                            },
                            child: Icon(Icons.timer)),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            onPressed: () {
              if (name == null ||
                  mobile == null ||
                  email == null ||
                  formattedDate == null ||
                  selectedTime == null) {
                Toast.show("Fields cannot be left blank!", context,
                    duration: Toast.LENGTH_LONG,
                    backgroundColor: Colors.black45,
                    gravity: Toast.CENTER);
              } else {
                ref.child("Reservations").push().update({
                  "customerName": name,
                  "customerMobile": mobile,
                  "customerEmail": email,
                  "date": formattedDate,
                  "time": selectedTime
                      .toString()
                      .substring(10, selectedTime.toString().length - 1)
                });
                Toast.show("Reservation created!", context,
                    duration: Toast.LENGTH_LONG,
                    backgroundColor: Colors.black45,
                    gravity: Toast.CENTER);
                Navigator.pop(context);
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
                side: BorderSide(color: Colors.red)),
            color: Colors.red,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Create Reservation",
                style: TextStyle(
                    color: Colors.white, fontFamily: "RedRose", fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
