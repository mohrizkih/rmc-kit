import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/models/user_data.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/ListDoctor/components/list_dokter_umum.dart';

class Bidan extends StatefulWidget {
  @override
  _BidanState createState() => _BidanState();
}

class _BidanState extends State<Bidan> {
  @override
  Widget build(BuildContext context) {
    Stream<List<UserData>> streamDoctor = DatabaseService().bidanData;
    return DaftarMedis(streamData: streamDoctor, title: 'Bidan');
  }
}
