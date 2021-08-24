import 'package:flutter/material.dart';
import 'package:rmc_kit/components/my_appbar.dart';
import 'components/sensor_read_body.dart';

class Sensor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MyAppBar(title: 'Sensor Read', press: () {Navigator.pop(context);}),
            Expanded(child: SensorReadBody()),
          ],
        ),
      ),
    );
  }
}
