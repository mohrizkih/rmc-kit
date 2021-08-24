import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmc_kit/components/authExceptionHandler.dart';
import 'package:rmc_kit/components/auth_result_status.dart';
import 'package:rmc_kit/components/email_validator.dart';
import 'package:rmc_kit/Screens/Auth/Welcome/wlcome_screen.dart';
import 'package:rmc_kit/components/loading.dart';
import 'package:rmc_kit/components/rounded_input.dart';
import 'package:rmc_kit/components/rrounded_button.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/Screens/Auth/Services/auth.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String _email, _password;
  String errorMsg;
  // bool _autoValidate = false;
  bool _loading = false;

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _loading
        ? Loading()
        : Form(
            key: _formKey,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/welcome.jpg'), fit: BoxFit.fitHeight)),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: size.height * 0.35),
                          Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.02),
                          RoundedInput(
                            initialValue: _email,
                            labelText: 'Email',
                            validator: emailValidator,
                            icon: Icons.mail,
                            onSaved: (value) {
                              _email = value;
                            },
                          ),
                          RoundedInput(
                            initialValue: _password,
                            labelText: 'Password',
                            icon: Icons.lock,
                            obsecure: true,
                            validator: (input) => input.isEmpty ? "*Required" : null,
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          RRoundedButton(
                            text: 'LOGIN',
                            press: signIn,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                erase();
                                Navigator.pushNamed(context, '/WelcomeBody');
                              });
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> signIn() async {
    final FormState _formState = _formKey.currentState;
    if (_formState.validate()) {
      _formState.save();
      setState(() {
        _loading = true;
      });
      final result = await AuthService().signInEmailandPassword(
        _email,
        _password,
      );
      if (result == AuthResultStatus.successful) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
        setState(() {
          _loading = false;
        });
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(result);
        print(errorMsg);
        return setState(() {
          _loading = false;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  child: Text(errorMsg),
                ),
              );
            },
          );
        });
      }
    }
  }
}
