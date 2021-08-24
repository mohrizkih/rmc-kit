import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/components/my_appbar.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/models/user_data.dart';

class InfoPage extends StatefulWidget {
  final String judul;
  final String isi;
  final String imgUrl;
  final String timestamp;
  final String pengirim;

  const InfoPage(
      {Key key,
      @required this.judul,
      @required this.isi,
      @required this.imgUrl,
      @required this.timestamp,
      @required this.pengirim})
      : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState(
      imgUrl: imgUrl, isi: isi, pengirim: pengirim, judul: judul, timestamp: timestamp);
}

class _InfoPageState extends State<InfoPage> {
  _InfoPageState(
      {@required this.imgUrl,
      @required this.isi,
      @required this.judul,
      @required this.pengirim,
      @required this.timestamp});
  final String judul;
  final String isi;
  final String imgUrl;
  final String timestamp;
  final String pengirim;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
        stream: DatabaseService(uid: pengirim).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          UserData userData = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    MyAppBar(
                      press: () => Navigator.pop(context),
                      title: 'Informasi Kesehatan',
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: (imgUrl == '' || imgUrl == null)
                                    ? AssetImage('assets/images/no image.png')
                                    : CachedNetworkImageProvider(imgUrl)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(judul,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(isi),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            child: Text(userData.namaLengkap),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            child: Text(
                              DateFormat('dd/MM').format(
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))),
                              style: TextStyle(
                                  color: secondColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
