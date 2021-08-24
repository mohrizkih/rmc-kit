import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/models/user_data.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/ListDoctor/components/list_dokter_umum.dart';

class ListPerawat extends StatefulWidget {
  @override
  _ListPerawatState createState() => _ListPerawatState();
}

class _ListPerawatState extends State<ListPerawat> {
  @override
  Widget build(BuildContext context) {
    Stream<List<UserData>> streamDoctor = DatabaseService().perawatData;
    return DaftarMedis(streamData: streamDoctor, title: 'Perawat');
  }
}

