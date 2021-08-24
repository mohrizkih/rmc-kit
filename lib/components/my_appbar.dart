import 'package:flutter/material.dart';
import 'package:rmc_kit/constant/color.dart';

class MyAppBar extends StatelessWidget {
  final Function press;
  final String title;
  MyAppBar({this.title, this.press});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(left: size.width * 0.01, right: size.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: press,
                icon: Icon(Icons.arrow_back),
              ),
              SizedBox(width: size.width * 0.01),
              Text(
                title,
                style: TextStyle(
                  color: primaryColor,
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.05,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/images/logo fix.png',
            height: size.height * 0.075,
          ),
        ],
      ),
    );
  }
}
