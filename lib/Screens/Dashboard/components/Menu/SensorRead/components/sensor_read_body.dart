import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/SensorRead/sensor.dart';
import 'package:rmc_kit/components/loading.dart';
import 'package:rmc_kit/components/rounded_input.dart';
import 'package:rmc_kit/components/rrounded_button.dart';
import 'package:rmc_kit/constant/color.dart';

String _pin = "";

class SensorConfirmation extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Masukkan PIN Perangkat Anda',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                RoundedInput(
                  labelText: 'PIN',
                  obsecure: true,
                  validator: (input) => input.isEmpty ? '*Wajib di isi' : null,
                  onSaved: (val) {
                    _pin = val;
                  },
                ),
                RRoundedButton(
                  text: 'Find Tools',
                  textColor: Colors.white,
                  color: Colors.red,
                  press: () {
                    final FormState _formState = _formKey.currentState;
                    if (_formState.validate()) {
                      _formState.save();
                      print(_pin);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Sensor()));
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SensorReadBody extends StatefulWidget {
  @override
  _SensorReadBodyState createState() => _SensorReadBodyState();
}

class _SensorReadBodyState extends State<SensorReadBody> {
  bool _isConnected = false;
  bool _finger = false;
  var _ref = FirebaseDatabase().reference();
  var _refSuhu = FirebaseDatabase().reference().child(_pin).child('Sensor').child('Suhu');
  var _refConnect = FirebaseDatabase().reference().child(_pin).child('Sensor').child('Connected');

  Widget isConnectedWidget(bool connect) {
    if (connect == true) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration:
                  BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: Text("Device is Connected", style: TextStyle(color: Colors.white)),
            ),
            Container(
              child: Text('Pastikan power sensor menyala dan terhubung dengan internet',
                  style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
        child: Text("Device is not Connected", style: TextStyle(color: Colors.white)),
      );
    }
  }

  String isConnectedButton(bool connect) {
    if (connect == true) {
      return "Disconnect";
    } else {
      return "Connect";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _ref.child(_pin).onValue,
      builder: (context, snapRoot) {
        if (!snapRoot.hasData) {
          return Loading();
        } else if (snapRoot.data.snapshot.value == null) {
          return Container(child: Text('Tools Not Found', style: TextStyle(fontSize: 70)));
        } else {
          return StreamBuilder(
              stream: _refConnect.onValue,
              builder: (context, snapConnect) {
                if (!snapConnect.hasData) {
                  return Loading();
                } else {
                  _isConnected = snapConnect.data.snapshot.value;
                  return StreamBuilder(
                      stream: _refSuhu.onValue,
                      builder: (context, snapSuhu) {
                        if (!snapSuhu.hasData) {
                          return Loading();
                        } else {
                          return StreamBuilder(
                              stream: _ref.child(_pin).child("Sensor").child("finger").onValue,
                              builder: (context, snapFinger) {
                                if (!snapFinger.hasData) {
                                  return Loading();
                                } else {
                                  _finger = snapFinger.data.snapshot.value;
                                  return StreamBuilder(
                                      stream: _ref
                                          .child(_pin)
                                          .child("Sensor")
                                          .child("heartbeat")
                                          .onValue,
                                      builder: (context, snapHeart) {
                                        if (!snapHeart.hasData) {
                                          return Loading();
                                        }
                                        return Container(
                                          child: Center(
                                            child: Column(
                                              children: <Widget>[
                                                isConnectedWidget(_isConnected),
                                                DisplaySensor(
                                                  sensorTag: "Suhu Tubuh",
                                                  readSensor:
                                                      snapSuhu.data.snapshot.value + " \u00B0C",
                                                  mainAxis: MainAxisAlignment.end,
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                DisplaySensor(
                                                  isHeartBeat: true,
                                                  finger: _finger,
                                                  readSensor:
                                                      snapHeart.data.snapshot.value + " bpm",
                                                  sensorTag: "Heartbeat",
                                                  mainAxis: MainAxisAlignment.start,
                                                ),
                                                RRoundedButton(
                                                  text: isConnectedButton(_isConnected),
                                                  color: primaryColor,
                                                  textColor: Colors.white,
                                                  press: () {
                                                    if (_isConnected == false) {
                                                      _ref.child(_pin).child('Sensor').update({
                                                        'Connected': true //yes I know.
                                                      });
                                                    } else {
                                                      _ref.child(_pin).child('Sensor').update({
                                                        'Connected': false //yes I know.
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              });
                        }
                      });
                }
              });
        }
      },
    );
  }
}

class DisplaySensor extends StatelessWidget {
  final String readSensor;
  final String sensorTag;
  final MainAxisAlignment mainAxis;
  final bool isHeartBeat;
  final bool finger;
  DisplaySensor(
      {this.readSensor,
      this.sensorTag,
      this.mainAxis,
      this.isHeartBeat = false,
      this.finger = false});

  Widget isFingerOn(bool finger) {
    if (finger == true) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
        child: Text("Letakkan jari di sensor detak jantung", style: TextStyle(color: Colors.white)),
      );
    }
  }

  Widget isHeartBeatOn(bool isHeartBeat) {
    if (isHeartBeat == true) {
      return isFingerOn(finger);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: mainAxis,
          children: <Widget>[
            Text(
              readSensor,
              style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              sensorTag,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            isHeartBeatOn(isHeartBeat),
          ],
        ),
      ),
    );
  }
}
