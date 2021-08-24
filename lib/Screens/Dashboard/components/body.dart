import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/Screens/Dashboard/components/menu_dashboard.dart';

import 'Menu/HealthInformation/components/info_page.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              Image.asset(
                'assets/images/logo fix.png',
                height: size.height * 0.18,
              ),
              // SizedBox(height: size.height *0.05,),
              Menu(),
              StreamBuilder(
                stream: DatabaseService().dataInfoKes3,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: snapshot.data.map<Widget>((data) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InfoPage(
                                        timestamp: data.timestamp,
                                        imgUrl: data.imgUrl,
                                        judul: data.title,
                                        isi: data.isi,
                                        pengirim: data.uid)));
                          },
                          child: Container(
                            height: size.height * 0.25,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: size.height * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: (data.imgUrl == '' || data.imgUrl == null)
                                            ? AssetImage('assets/images/no image.png')
                                            : CachedNetworkImageProvider(data.imgUrl)),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.grey.withOpacity(0.0),
                                          Colors.black,
                                        ],
                                        stops: [
                                          0.0,
                                          0.5,
                                          1.0,
                                        ]),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 5, left: 10),
                                    child: Text(
                                      data.title.toUpperCase(),
                                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
