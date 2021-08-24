import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rmc_kit/models/infoKes.dart';
import 'package:rmc_kit/models/user_data.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //referensi koleksi untuk cloudfirestore
  final CollectionReference userPrivateData =
      FirebaseFirestore.instance.collection('Data Pribadi Pengguna');
  final CollectionReference infoKesehatan =
      FirebaseFirestore.instance.collection('infoKesehatan');

  //digunakan untuk fungsi onsendMessage di chat.dart
  messageSend(String chatId, String myId, String peerId, String peerName,
      String content) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection(chatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    var documentReference2 =
        FirebaseFirestore.instance.collection('messages').doc(chatId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, {
        'idFrom': myId,
        'idTo': peerId,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': content,
      });
      transaction.set(documentReference2, {
        'idUser': myId,
        'idDoc': peerId,
        'nameDoc': peerName,
        'content': content,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
  }

  Future setUserData(String email, String nama, String tglLahir, String gender,
      String role, String uidd) async {
    return await userPrivateData.doc(uid).set(
      {
        'Email': email,
        'namaLengkap': nama,
        'Tanggal Lahir': tglLahir,
        'Jenis Kelamin': gender,
        'role': role,
        'uid': uidd,
        'imageUrl': '',
      },
    );
  }

  //Membuat List Doctor umum dari firebase
  List<UserData> _userDataForGeneralDoc(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
        uid: doc.data()['uid'] ?? '',
        role: doc.data()['role'] ?? '',
        namaLengkap: doc.data()['namaLengkap'] ?? '',
        imageUrl: doc.data()['imageUrl'] ?? '',
        tempatPraktek: doc.data()['Tempat Praktek'] ?? '',
      );
    }).toList();
  }

  Stream<List<UserData>> get doctorData {
    return userPrivateData
        .where("role", isEqualTo: "Dokter Umum")
        .orderBy("namaLower")
        .snapshots()
        .map(_userDataForGeneralDoc);
  }

  Stream<List<UserData>> get perawatData {
    return userPrivateData
        .where("role", isEqualTo: "Perawat")
        .orderBy("namaLower")
        .snapshots()
        .map(_userDataForGeneralDoc);
  }

  Stream<List<UserData>> get bidanData {
    return userPrivateData
        .where("role", isEqualTo: "Bidan")
        .orderBy("namaLower")
        .snapshots()
        .map(_userDataForGeneralDoc);
  }

  //ambil data dari firestore dan disimpan ke model UserData
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid ?? '',
      role: snapshot.data()['role'] ?? '',
      email: snapshot.data()['Email'] ?? '',
      namaLengkap: snapshot.data()['namaLengkap'] ?? '',
      gender: snapshot.data()['Jenis Kelamin'] ?? '',
      tglLahir: snapshot.data()['Tanggal Lahir'] ?? '',
      imageUrl: snapshot.data()['imageUrl'] ?? '',
    );
  }

  Stream<UserData> get userData {
    return userPrivateData.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //---------------------------------- Info Kesehatan-------------------------------------------
  List<DataInfoKes> _infoFromSnapshot2(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DataInfoKes(
        title: doc.data()['judul'] ?? '',
        isi: doc.data()['isi'] ?? '',
        uid: doc.data()['pengirim'] ?? '',
        timestamp: doc.data()['timestamp'] ?? '',
        imgUrl: doc.data()['imageUrl'] ?? '',
      );
    }).toList();
  }

  Stream<List<DataInfoKes>> get dataInfoKes2 {
    return infoKesehatan
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_infoFromSnapshot2);
  }

  Stream<List<DataInfoKes>> get dataInfoKes3 {
    return infoKesehatan
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map(_infoFromSnapshot2);
  }
}
