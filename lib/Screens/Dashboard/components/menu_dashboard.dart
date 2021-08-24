import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/Consultation/consultation.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/HealthInformation/healt_information.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/ListDoctor/list_doctor.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/SensorRead/components/sensor_read_body.dart';
import 'package:rmc_kit/constant/color.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisSpacing: 18,
        mainAxisSpacing: 0,
        children: myMenu.map((data) {
          return Container(
            margin: EdgeInsets.only(top: size.height * 0.02),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(4, 6), // changes position of shadow
                ),
              ],
            ),
            child: TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.all(5.0)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => data.event));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Image.asset(
                      data.img,
                      width: size.width * 0.19,
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    data.title,
                    style: TextStyle(color: Colors.white, fontSize: size.width * 0.045),
                  ),
                  Text(
                    data.subtitle,
                    style: TextStyle(color: Colors.white, fontSize: size.width * 0.03),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Items {
  final String title;
  final String subtitle;
  final Widget event;
  final String img;
  Items({this.title, this.subtitle, this.event, this.img});
}

List<Items> myMenu = [
  Items(
    title: 'Daftar Medis',
    subtitle: 'Mulai kontak tenaga medis di sini',
    event: ListDoctor(),
    img: "assets/images/id-card.png",
  ),
  Items(
    title: 'Riwayat Chat',
    subtitle: 'Riwayat perpesanan dengan tenaga medis',
    event: Consultation(),
    img: "assets/images/medical-app.png",
  ),
  Items(
    title: 'Sensor',
    subtitle: 'Cek Suhu tubuh dan detak jantung',
    event: SensorConfirmation(),
    img: "assets/images/heart-rate-monitor.png",
  ),
  // Items(
  //   title: 'Sensor History',
  //   subtitle: 'History of yout heartbeat and temperature measurement',
  //   event: SensorHistory(),
  //   img: "assets/images/form.png",
  // ),
  Items(
    title: 'Informasi Kesehatan',
    subtitle: 'Informasi seputar dunia kesehatan dari tenaga medis',
    event: HealthInfo(),
    img: "assets/images/medical-handbook.png",
  ),
];
