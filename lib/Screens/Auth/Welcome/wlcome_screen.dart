import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Welcome/components/welcome_body.dart';
import 'package:provider/provider.dart';
import 'package:rmc_kit/Screens/Dashboard/dashboard.dart';
import 'package:rmc_kit/models/user.dart';


int _myNum = 1;
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    if (_myNum == 0) {
      return WelcomeBody();
    } else {
      if (user == null) {
        return WelcomeBody();
      } else {
        return Dashboard(myId: user.uid);
      }
    }
  }

  
}

click() {
    _myNum++;
  }

  erase() {
    _myNum = 0;
  }