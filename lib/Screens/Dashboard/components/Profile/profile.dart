import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/components/date_picker_form.dart';
import 'package:rmc_kit/components/loading.dart';
import 'package:rmc_kit/components/my_appbar.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/models/user.dart';
import 'package:rmc_kit/models/user_data.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    final _formKey = GlobalKey<FormState>();
    final _picker = ImagePicker();
    List<String> gender = ['Laki-laki', 'Perempuan'];
    File _image;

    final CollectionReference dataPengguna =
        FirebaseFirestore.instance.collection('Data Pribadi Pengguna');

    Future updateNama(String namaTerbaru) async {
      return await dataPengguna.doc(user.uid).update({
        'namaLengkap': namaTerbaru,
      });
    }

    Future updateGender(String genderTerbaru) async {
      return await dataPengguna.doc(user.uid).update({
        'Jenis Kelamin': genderTerbaru,
      });
    }

    Future updateBirth(String birthTerbaru) async {
      return await dataPengguna.doc(user.uid).update({
        'Tanggal Lahir': birthTerbaru,
      });
    }

    Future uploadPic(BuildContext context) async {
      PickedFile imagePicked = await _picker.getImage(source: ImageSource.gallery);
      _image = File(imagePicked.path);

      String fileName = path.basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(user.uid).child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

      uploadTask.onComplete.then((snapshot) async {
        if (snapshot.error == null) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection("Data Pribadi Pengguna")
              .doc(user.uid)
              .set({"imageUrl": downloadUrl, "fileName": fileName}, SetOptions(merge: true));

          final snackBar = SnackBar(content: Text('Yay! Success'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          print('Error from image repo ${snapshot.error.toString()}');
          throw ('This file is not an image');
        }
      });

      setState(() {
        print("Profile Picture uploaded");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    Widget closePosition() {
      return Positioned(
        right: -40.0,
        top: -40.0,
        child: InkResponse(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: CircleAvatar(
            child: Icon(Icons.close),
            backgroundColor: Colors.red,
          ),
        ),
      );
    }

    editNama(String initialValue) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            String _namaTerbaru;
            return AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  closePosition(),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (input) => input.isEmpty ? "*Wajib di isi" : null,
                            initialValue: initialValue ?? "",
                            onSaved: (input) => _namaTerbaru = input,
                            decoration: InputDecoration(
                              labelText: "Nama Lengkap",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                try {
                                  await updateNama(_namaTerbaru);
                                } catch (e) {
                                  print(e);
                                }
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    editGender(String initialValue) {
      String _currentGender;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  closePosition(),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DropdownButtonFormField(
                            items: gender.map((String cList) {
                              return DropdownMenuItem(value: cList, child: Text(cList));
                            }).toList(),
                            onChanged: (input) => _currentGender = input,
                            value: initialValue,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                try {
                                  await updateGender(_currentGender);
                                } catch (e) {
                                  print(e);
                                }
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    editBirth(String initialValue) {
      String _currentBirth;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  closePosition(),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DatePickerForm(
                            initialValue: initialValue,
                            onChanged: (input) {
                              _currentBirth = input;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                try {
                                  await updateBirth(_currentBirth);
                                } catch (e) {
                                  print(e);
                                }
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              MyAppBar(
                title: 'Profile',
                press: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StreamBuilder<UserData>(
                        stream: DatabaseService(uid: user.uid).userData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserData userData = snapshot.data;
                            String _imageUrl = userData.imageUrl;
                            var parsedDate = DateTime.parse(userData.tglLahir);
                            String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    _imageUrl == ''
                                        ? Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  AssetImage('assets/images/user-profile.png'),
                                              radius: 80,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(_imageUrl),
                                              radius: 80,
                                            ),
                                          ),
                                    Positioned(
                                      right: -3,
                                      bottom: -3,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.photo_camera,
                                            color: Colors.grey,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            uploadPic(context);
                                          }),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 3),
                                  child: Text(
                                    userData.email,
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black, fontFamily: 'Pacifico'),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: Divider(
                                    color: secondColor,
                                  ),
                                ),
                                Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  columnWidths: {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(6),
                                    2: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(children: [
                                      TextContainer(
                                        isi: 'Nama Lengkap',
                                        conColor: secondColor,
                                        textColor: primaryColor,
                                      ),
                                      TextContainer(isi: userData.namaLengkap),
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            setState(() {
                                              editNama(userData.namaLengkap);
                                            });
                                          }),
                                    ]),
                                    TableRow(children: [
                                      TextContainer(
                                        isi: 'Jenis Kelamin',
                                        conColor: secondColor,
                                        textColor: primaryColor,
                                      ),
                                      TextContainer(isi: userData.gender),
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            setState(() {
                                              editGender(userData.gender);
                                            });
                                          }),
                                    ]),
                                    TableRow(children: [
                                      TextContainer(
                                        isi: 'Tanggal Lahir',
                                        conColor: secondColor,
                                        textColor: primaryColor,
                                      ),
                                      TextContainer(isi: formattedDate),
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            setState(() {
                                              editBirth(userData.tglLahir);
                                            });
                                          }),
                                    ]),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Loading();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextContainer extends StatelessWidget {
  final String isi;
  final Color conColor;
  final Color textColor;

  TextContainer({this.isi, this.conColor = Colors.white, this.textColor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: conColor,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 4, top: 0),
      child: Text(
        isi,
        style: TextStyle(color: textColor, fontSize: 15.0),
      ),
    );
  }
}
