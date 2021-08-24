import 'package:flutter/material.dart';
import 'package:rmc_kit/components/my_appbar.dart';

import 'components/consultation_body.dart';

class Consultation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              MyAppBar(
                  title: 'Consultation', press: () => Navigator.pop(context)),
              ConsulBody(),
            ],
          ),
        ),
      ),
    );
  }
}
