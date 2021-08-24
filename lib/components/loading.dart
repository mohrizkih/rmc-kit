import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/constant/color.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondColor[200],
      child: Center(
        child: SpinKitWanderingCubes(
          color: primaryColor,
          size: 60.0,
        ),
      ),
    );
  }
}
