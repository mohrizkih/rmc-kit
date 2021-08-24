import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/Consultation/components/chat.dart';
import 'package:rmc_kit/components/loading.dart';
import 'package:rmc_kit/components/my_appbar.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/models/user.dart';
import 'package:rmc_kit/models/user_data.dart';

class GeneralDoc extends StatefulWidget {
  @override
  _GeneralDocState createState() => _GeneralDocState();
}

class _GeneralDocState extends State<GeneralDoc> {
  @override
  Widget build(BuildContext context) {
    Stream<List<UserData>> streamDoctor = DatabaseService().doctorData;
    return DaftarMedis(streamData: streamDoctor, title: 'Dokter Umum');
  }
}

class DaftarMedis extends StatefulWidget {
  final Stream<List<UserData>> streamData;
  final String title;

  DaftarMedis({@required this.streamData, @required this.title});

  @override
  _DaftarMedisState createState() => _DaftarMedisState();
}

class _DaftarMedisState extends State<DaftarMedis> {
  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<UserData>>(
        stream: widget.streamData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();
          List<UserData> listDoctor = snapshot.data;
          return Scaffold(
            body: SafeArea(
              child: Column(children: <Widget>[
                MyAppBar(
                    title: widget.title,
                    press: () {
                      Navigator.pop(context);
                    }),
                Flexible(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 4.5,
                      mainAxisSpacing: size.height * 0.0,
                      children: listDoctor.map((data) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(size.height * 0.02),
                            color: secondColor,
                          ),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: CircleAvatar(
                                    radius: size.height * 0.045,
                                    backgroundImage: data.imageUrl == ''
                                        ? AssetImage('assets/images/user-profile.png')
                                        : CachedNetworkImageProvider(data.imageUrl),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(data.namaLengkap,
                                            style: TextStyle(
                                                fontSize: size.height * 0.025,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        Text(data.tempatPraktek,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: size.height * 0.02)),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Chat(
                                                peerName: data.namaLengkap,
                                                myId: user.uid,
                                                peerId: data.uid)));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Message',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                ),
              ]),
            ),
          );
        });
  }
}
