import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/models/user.dart';
import 'package:rmc_kit/models/user_data.dart';

class Sidebar extends StatelessWidget {
  final Function closeDrawer;
  const Sidebar({Key key, this.closeDrawer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<MyUser>(context);

    logOutConfirm() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Log out"),
              content: Text("Keluar dari akun ini?"),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                CupertinoDialogAction(
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        return Navigator.pop(context); 
                      } catch (error) {
                        print(error.toString());
                        return null;
                      }
                    }),
              ],
            );
          });
    }

    exitConfirm() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Keluar Aplikasi"),
              content: Text("Keluar dari aplikasi ini?"),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                CupertinoDialogAction(
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      try {
                        return SystemNavigator.pop(); 
                      } catch (error) {
                        print(error.toString());
                        return null;
                      }
                    }),
              ],
            );
          });
    }

    return Drawer(
      child: Column(
        children: <Widget>[
          StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.05),
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/user-profile.png'),
                          radius: size.width * 0.15,
                        ),
                      ),
                      Text(
                        'Nama User',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: 'Pacifico'),
                      ),
                      Text(
                        'user@email.com',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      )
                    ],
                  ),
                ),
              );
              }
              UserData userData = snapshot.data;
              String _imageUrl = userData.imageUrl;
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: size.height * 0.05),
                        child: CircleAvatar(
                          backgroundImage: _imageUrl == '' 
                          ? AssetImage('assets/images/user-profile.png')
                          : CachedNetworkImageProvider(_imageUrl),
                          radius: size.width * 0.15,
                        ),
                      ),
                      Text(
                        userData.namaLengkap,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: 'Pacifico'),
                      ),
                      Text(
                        userData.email,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      )
                    ],
                  ),
                ),
              );
            }
          ),
          // SizedBox(height: size.height * 0.02),
          SizedBox(
            child: Divider(
              color: secondColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profile()));
              // closeDrawer();
            },
          ),
          SizedBox(
            child: Divider(
              color: secondColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock_open),
            title: Text(
              'Log out',
              style: TextStyle(),
            ),
            onTap: logOutConfirm,
          ),
          SizedBox(
            child: Divider(
              color: secondColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Exit',
              style: TextStyle(),
            ),
            onTap: exitConfirm,
          ),
          SizedBox(
            child: Divider(
              color: secondColor,
            ),
          ),
        ],
      ),
    );
  }
}
