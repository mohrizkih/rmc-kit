import 'package:rmc_kit/Screens/Auth/Services/database_service.dart';
import 'package:rmc_kit/components/authExceptionHandler.dart';
import 'package:rmc_kit/components/auth_result_status.dart';
import 'package:rmc_kit/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthResultStatus _status;
  
  MyUser userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(userFromFirebaseUser);
  }

  //register with email and password
  Future<AuthResultStatus> signUpWithEmailandPassword(
      String email, String password, String namaLengkap, String tglLahir, String gender, String role,) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //buat dokumen baru untuk user baru pada koleksi userPrivateData
      await DatabaseService(uid: user.uid).setUserData(email, namaLengkap, tglLahir, gender, role, user.uid);
      if (user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
      // return AuthService().userFromFirebaseUser(user);
    } catch (e) {
      print('Exception @signUp : $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  //login with email and password
  Future<AuthResultStatus> signInEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //buat dokumen baru untuk user baru pada koleksi userPrivateData
      if (user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
      // return AuthService().userFromFirebaseUser(user);
    } catch (e) {
      print('Exception @signUp : $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }
}
