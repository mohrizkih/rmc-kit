import 'package:rmc_kit/components/auth_result_status.dart';

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case 'email-already-in-use':
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case 'user-not-found':
        status = AuthResultStatus.userNotFound;
        break;
      case 'wrong-password':
        status = AuthResultStatus.wrongPassword;
        break;
      case 'weak-password':
        status = AuthResultStatus.weakPassword;
        break;
      case 'user-disabled':
        status = AuthResultStatus.userDisabled;
        break;
      
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = 'Email tersebut sudah digunakan';
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = 'Pengguna dengan email tersebut tidak ditemukan';
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = 'Password tidak sesuai dengan email';
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = 'Password Anda terlalu lemah';
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = 'User di non-aktifkan oleh admin';
        break;
      default:
        errorMessage = 'error tidak teridentifikasi';
    }
    return errorMessage;
  }
}
