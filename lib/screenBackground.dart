import 'package:flutter/material.dart';

class ScaffoldBG extends StatelessWidget {
  ScaffoldBG(
      {@required this.cardChild,
      @required this.cardColor,
      @required this.bgColor});
  final Widget cardChild;
  final Color bgColor;
  final Color cardColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30.0, right: 30, top: 70, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15), color: cardColor),
                child: cardChild,
              ),
            ),
          )
        ],
      ),
    );
  }
}
