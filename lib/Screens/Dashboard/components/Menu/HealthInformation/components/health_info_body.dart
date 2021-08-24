import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/HealthInformation/components/info_page.dart';

class HealthInfoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StreamBuilder(
              stream: DatabaseService().dataInfoKes2,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Column(
                  children: snapshot.data.map<Widget>((data) {
                    return TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
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
                        height: size.height * 0.22,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: size.height * 0.22,
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
                              height: size.height * 0.22,
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
                );
              }),
        ],
      ),
    );
  }
}

class InfoSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: DatabaseService().dataInfoKes2,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('tidak ada data'),
          );
        }

        final results = snapshot.data;
        return ListView(
          children: results.map<Widget>((data) {
            String _judul = data.title;
            if (_judul.toLowerCase().contains(query.toLowerCase())) {
              return TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPage(
                              timestamp: data.timestamp,
                              imgUrl: data.imgUrl,
                              judul: data.title,
                              isi: data.isi,
                              pengirim: data.uid)));
                  // close(context, null);
                },
                child: Container(
                  height: size.height * 0.22,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.22,
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
                        height: size.height * 0.22,
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
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseService().dataInfoKes2,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('tidak ada data'),
          );
        }

        final results = snapshot.data;
        return ListView(
          children: results.map<Widget>((a) {
            String _judul = a.title;
            if (_judul.toLowerCase().contains(query.toLowerCase())) {
              return ListTile(
                title: Text(
                  _judul,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 20.0),
                ),
                onTap: () {
                  query = _judul;
                },
              );
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }
}
