import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/Consultation/components/chat.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/models/user.dart';
import 'package:rmc_kit/models/user_data.dart';

class ConsulBody extends StatefulWidget {
  @override
  _ConsulBodyState createState() => _ConsulBodyState();
}

class _ConsulBodyState extends State<ConsulBody> {
  List<QueryDocumentSnapshot> listMedis = new List.from([]);

  Widget buildItem(BuildContext context, int index, DocumentSnapshot document, String myId) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: document.data()["idDoc"]).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            UserData userData = snapshot.data;
            String _imageUrl = userData.imageUrl;
            String _isiPesan = document.data()["content"];
            print(size.height * 0.024);
            return Container(
              width: double.infinity,
              height: size.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(5, 3), // changes position of shadow
                  ),
                ],
                // border: Border(bottom: BorderSide(color: secondColor)),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chat(
                              peerName: userData.namaLengkap,
                              myId: myId,
                              peerId: document.data()["idDoc"])));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.height * 0.033,
                      backgroundImage: _imageUrl == ''
                          ? AssetImage('assets/images/user-profile.png')
                          : CachedNetworkImageProvider(_imageUrl),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  userData.namaLengkap,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  _isiPesan.length < 30
                                      ? _isiPesan
                                      : _isiPesan.substring(0, 29) + '...',
                                  style: TextStyle(fontSize: 17, color: secondColor),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            DateFormat('dd/MM').format(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document.data()['timestamp']))),
                            style: TextStyle(
                                color: secondColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                          ),
                        ),
                        Container(
                          child: Text(
                            DateFormat('kk:mm').format(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document.data()['timestamp']))),
                            style: TextStyle(
                                color: secondColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    Stream stream1 = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .where("idUser", isEqualTo: user.uid)
        .snapshots();
    return StreamBuilder(
        stream: stream1,
        builder: (context, snapshot1) {
          if (!snapshot1.hasData) {
            return Container(
              child: Text('kosong'),
            );
          } else {
            listMedis.addAll(snapshot1.data.documents);
            return SingleChildScrollView(
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  // padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, index, snapshot1.data.documents[index], user.uid),
                  itemCount: snapshot1.data.documents.length,
                ),
              ),
            );
          }
        });
  }
}
