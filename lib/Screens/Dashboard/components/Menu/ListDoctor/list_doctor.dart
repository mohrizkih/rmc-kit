import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/ListDoctor/components/list_bidan.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/ListDoctor/components/list_dokter_umum.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/ListDoctor/components/list_perawat.dart';
import 'package:rmc_kit/components/my_appbar.dart';
import 'package:rmc_kit/constant/color.dart';

class ListDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MyAppBar(
              title: 'Kriteria Tenaga Medis',
              press: () {
                Navigator.pop(context);
              },
            ),
            BodyListDoctor(),
          ],
        ),
      ),
    );
  }
}

class BodyListDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Flexible(
      child: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 3,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisSpacing: 18,
        mainAxisSpacing: 0,
        children: category.map((data) {
          String _image = data.image;
          return Container(
            margin: EdgeInsets.only(top: size.height * 0.02),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => data.event));
              },
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: size.height * 0.06,
                    backgroundImage: AssetImage('assets/images/$_image'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            data.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * 0.027,
                                color: Colors.white),
                          ),
                          Text(
                            data.subtitle,
                            style: TextStyle(color: Colors.white, fontSize: size.height * 0.017),
                            textAlign: TextAlign.justify,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
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

// Kategori tenaga medis
class Category {
  final String title;
  final String subtitle;
  final Widget event;
  final String image;
  Category({this.title, this.subtitle, this.event, this.image});
}

List<Category> category = [
  Category(
      title: 'Dokter Umum',
      subtitle:
          'Memberikan pelayanan medis, informasi kesehatan, serta dapat memberikan anjuran obat yang dapat digunakan pasien',
      event: GeneralDoc(),
      image: 'doctor (2).png'),
  Category(
      title: 'Bidan',
      subtitle: 'Memberikan informasi kesehatan khusus kepada ibu dan anak',
      event: Bidan(),
      image: 'pregnancy.png'),
  Category(
      title: 'Perawat',
      subtitle:
          'Memberikan informasi kesehatan dan apabila diperlukan dapat memberikan rekomendasi obat-obat umum',
      event: ListPerawat(),
      image: 'nurse (1).png'),
];
