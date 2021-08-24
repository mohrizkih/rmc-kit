import 'package:flutter/material.dart';
import 'package:rmc_kit/components/my_appbar.dart';

import 'components/health_info_body.dart';

class HealthInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showSearch(context: context, delegate: InfoSearch());
        },
        child: Icon(Icons.search),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyAppBar(title: 'Health Information', press: () {Navigator.pop(context);},),
              HealthInfoBody(),// Body(),
            ],
          ),
        ),
      ),
    );
  }
}