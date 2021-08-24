import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/Screens/Dashboard/components/Menu/SensorRead/components/sensor_read_body.dart';
import 'package:rmc_kit/components/loading.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:rmc_kit/models/user_data.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String myId;
  final String peerName;
  Chat({Key key, @required this.peerId, @required this.myId, @required this.peerName});
  @override
  Widget build(BuildContext context) {
    List<String> toSensor = ["Sensor"];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondColor,
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.arrow_drop_down_circle),
              onSelected: (select) {
                FirebaseFirestore.instance
                    .collection('Data Pribadi Pengguna')
                    .doc(myId)
                    .update({'chattingWith': ''});
                return Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SensorConfirmation()));
              },
              itemBuilder: (BuildContext context) {
                return toSensor.map((String sensor) {
                  return PopupMenuItem<String>(
                      value: sensor,
                      child: Center(
                          child: Text(
                        sensor,
                        textAlign: TextAlign.center,
                      )));
                }).toList();
              }),
        ],
        title: StreamBuilder<UserData>(
            stream: DatabaseService(uid: peerId).userData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              UserData userData = snapshot.data;
              String _imageUrl = userData.imageUrl;
              return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 25,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Data Pribadi Pengguna')
                              .doc(myId)
                              .update({'chattingWith': ''});
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 6, right: 10),
                      child: _imageUrl == ''
                          ? CircleAvatar(
                              radius: size.height * 0.025,
                              child: Image.asset('assets/images/user-profile.png'))
                          : CircleAvatar(
                              radius: size.height * 0.025,
                              backgroundImage: CachedNetworkImageProvider(_imageUrl),
                            ),
                    ),
                    Text(peerName),
                  ],
                ),
              );
            }),
      ),
      body: ChatScreen(peerId: peerId, myId: myId, peerName: peerName),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String myId;
  final String peerName;

  ChatScreen({
    Key key,
    @required this.peerId,
    @required this.myId,
    @required this.peerName,
  }) : super(key: key);
  @override
  _ChatScreenState createState() =>
      _ChatScreenState(peerId: peerId, myId: myId, peerName: peerName);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState({@required this.peerId, @required this.peerName, @required this.myId});
  String peerId;
  String peerName;
  String myId;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  bool isLoading;

  String chatId;
  int _limit = 20;
  final int _limitIncrement = 20;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <= listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    isLoading = true;

    chatId = '';

    makeChatId();
  }

  makeChatId() {
    if (myId.hashCode <= peerId.hashCode) {
      chatId = '$myId-$peerId';
    } else {
      chatId = '$peerId-$myId';
    }

    print(peerId);

    FirebaseFirestore.instance
        .collection('Data Pribadi Pengguna')
        .doc(myId)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();
      DatabaseService().messageSend(chatId, myId, peerId, peerName, content);
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.data()['idFrom'] == myId) {
      return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration:
                      BoxDecoration(color: secondColor, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 50.0),
                )
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(document.data()['timestamp']))),
                style: TextStyle(color: secondColor, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0),
            )
          ],
        ),
      );
    } else {
      //pesan pengirim
      return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration:
                      BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(document.data()['timestamp']))),
                style: TextStyle(color: secondColor, fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 150.0),
            )
          ],
        ),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].data()['idFrom'] == myId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].data()['idFrom'] != myId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection('Data Pribadi Pengguna')
        .doc(myId)
        .update({'chattingWith': ''});
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Input content
              buildInput(),
            ],
          ),
          // buildLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Edit text
        Flexible(
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.lightBlueAccent,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 110,
              ),
              child: TextField(
                // maxLines: null,
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text);
                },
                style: TextStyle(color: primaryColor, fontSize: 18.0),
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: secondColor),
                  border: InputBorder.none,
                ),
                focusNode: focusNode,
              ),
            ),
          ),
        ),

        // Button send message
        Material(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 4, 7),
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(30)),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => onSendMessage(textEditingController.text),
              color: Colors.white,
            ),
          ),
          color: Colors.white,
        ),
      ],
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: chatId == ''
          ? Center(
              child:
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(chatId)
                  .collection(chatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red)));
                } else {
                  listMessage.addAll(snapshot.data.documents);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
