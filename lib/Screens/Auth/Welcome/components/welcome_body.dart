import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Welcome/wlcome_screen.dart';
import 'package:rmc_kit/components/rrounded_button.dart';
import 'package:rmc_kit/constant/color.dart';

// ignore: must_be_immutable
class WelcomeBody extends StatefulWidget {
  
  @override
  _WelcomeBodyState createState() => _WelcomeBodyState();
}

class _WelcomeBodyState extends State<WelcomeBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/welcome.jpg'),
                fit: BoxFit.fitHeight)),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Welcome to RMC kit',
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Pacifico',
                          // fontWeight: FontWeight.bold,
                          color: primaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: size.height * 0.6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RRoundedButton(
                        text: 'LOGIN',
                        color: primaryColor,
                        textColor: secondColor[200],
                        press: () {
                          setState(() {
                            click();
                            Navigator.pushNamed(context, '/login');
                          });
                        },
                      ),
                      RRoundedButton(
                        text: 'Sign Up',
                        color: secondColor[200],
                        textColor: primaryColor,
                        press: () {
                          setState(() {
                            click();
                            Navigator.pushNamed(context, '/signUp');
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
