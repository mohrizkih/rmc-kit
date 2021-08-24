import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Services/auth.dart';
import 'package:rmc_kit/components/authExceptionHandler.dart';
import 'package:rmc_kit/components/auth_result_status.dart';
import 'package:rmc_kit/components/date_picker_form.dart';
import 'package:rmc_kit/components/dropdown_button.dart';
import 'package:rmc_kit/components/email_validator.dart';
import 'package:rmc_kit/components/loading.dart';
import 'package:rmc_kit/components/rounded_input.dart';
import 'package:rmc_kit/Screens/Auth/Welcome/wlcome_screen.dart';
import 'package:rmc_kit/components/rrounded_button.dart';
import 'package:rmc_kit/constant/color.dart';

class SignupBody extends StatefulWidget {
  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String _email, _password;
  String _confirmPassword;
  String _namaLengkap;
  String _currentGender;
  String _tglLahir;
  List<String> gender = ['Laki-laki', 'Perempuan'];
  bool _loading = false;

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
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.02),
                          RoundedInput(
                            initialValue: _namaLengkap,
                            labelText: 'Nama Lengkap',
                            icon: Icons.text_fields,
                            onSaved: (value) {
                              _namaLengkap = value;
                            },
                          ),
                          RoundedInput(
                            initialValue: _email,
                            labelText: 'Email',
                            icon: Icons.mail,
                            validator: emailValidator,
                            onSaved: (value) => _email = value,
                          ),
                          DatePickerForm(
                            initialValue: _tglLahir,
                            onChanged: (input) {
                              _tglLahir = input;
                            },
                          ),
                          CustomDropDown(
                            hint: 'Jenis Kelamin',
                            list: gender,
                            icon: Icons.hdr_weak,
                            onChanged: (value) {
                              setState(() {
                                _currentGender = value;
                                print(_currentGender);
                              });
                            },
                          ),
                          RoundedInput(
                            initialValue: _password,
                            labelText: 'Password',
                            icon: Icons.lock,
                            validator: (input) => input.isEmpty ? "*Wajib diisi" : null,
                            obsecure: true,
                            onSaved: (value) {
                              _password = value;
                            },
                            onChanged: (value) => _password = value,
                          ),
                          RoundedInput(
                            initialValue: _confirmPassword,
                            labelText: 'Confirm Password',
                            icon: Icons.lock,
                            obsecure: true,
                            validator: (input) {
                              if (input.isEmpty) {
                                return '*Wajib di isi';
                              } else if (input != _password) {
                                print(input);
                                print(_password);
                                return '*Harus sesuai dengan password anda';
                              } else
                                return null;
                            },
                            onSaved: (value) => _confirmPassword = value,
                          ),
                          RRoundedButton(
                            text: 'Sign Up',
                            press: signUp,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                erase();
                                Navigator.pop(context);
                              });
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> signUp() async {
    final FormState _formState = _formKey.currentState;
    final String _role = 'user';

    if (_formState.validate()) {
      _formState.save();
      setState(() {
        _loading = true;
      });
      final result = await AuthService().signUpWithEmailandPassword(
          _email, _password, _namaLengkap, _tglLahir, _currentGender, _role);
      if (result == AuthResultStatus.successful) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
        setState(() {
          _loading = false;
        });
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(result);
        print(errorMsg);
        setState(() {
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
