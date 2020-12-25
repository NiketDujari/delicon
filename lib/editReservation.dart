import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class EditReservation extends StatefulWidget {
  String name;
  String mobile;
  String email;
  String date;
  String time;
  String dbkey;
  EditReservation(
      this.name, this.mobile, this.email, this.date, this.time, this.dbkey);
  @override
  _EditReservationState createState() => _EditReservationState();
}

class _EditReservationState extends State<EditReservation> {
  DateTime dateTime;
  String formattedDate;
  TimeOfDay selectedTime;
  String time;
  String name;
  String mobile;
  String email;
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  final ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    mobileController.text = widget.mobile;
    emailController.text = widget.email;
    formattedDate = widget.date;
    time = widget.time;
    name = widget.name;
    mobile = widget.mobile;
    email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          "Edit Reservation",
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
                        controller: nameController,
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
                        controller: mobileController,
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
                        controller: emailController,
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
                        Text("   Date:  "),
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
                          child: Text(time != null ? time : ""),
                        ),
                        GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((timez) {
                                setState(() {
                                  selectedTime = timez;
                                  time = selectedTime.toString().substring(
                                      10, selectedTime.toString().length - 1);
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            onPressed: () {
              if (name == null ||
                  mobile == null ||
                  email == null ||
                  formattedDate == null ||
                  time == null) {
                Toast.show("Fields cannot be left blank!", context,
                    duration: Toast.LENGTH_LONG,
                    backgroundColor: Colors.black45,
                    gravity: Toast.CENTER);
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('Do you want to save these changes?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No, cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              ref
                                  .child("Reservations")
                                  .child(widget.dbkey)
                                  .update({
                                "customerName": name,
                                "customerMobile": mobile,
                                "customerEmail": email,
                                "date": formattedDate,
                                "time": selectedTime != null
                                    ? selectedTime.toString().substring(
                                        10, selectedTime.toString().length - 1)
                                    : time
                              });
                              Toast.show("Changes saved!", context,
                                  duration: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.black45,
                                  gravity: Toast.CENTER);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            color: Colors.red,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                "Save changes",
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
