import 'package:onenizam/headers.dart';

class AccessContianer {
  static Map<String, String> data = {};

  static String addAccessWV(String rollNo) {
    //if exist return already existed token
    final t = data[rollNo];
    if (t != null) return t;
    // else create a new token and return it
    final token = ObjectId().toHexString();
    data[rollNo] = token;
    return token;
  }

  static bool isValid(String? rollNo, String? token) {
    final err1 = Credential.isValidRollNo(rollNo);
    final err2 = Access.isValidToken(token);
    ApiResponseHandler.ifExistThrowErrors([err1, err2]);
    return _isValidWV(rollNo!, token!);
  }

  static bool _isValidWV(String rollNo, String token) {
    return data[rollNo] == token;
  }

  static bool isValidAcess(Map<String, String>? access) {
    if (access == null) {
      ApiResponseHandler.ifExistThrowErrors(['Access Requrired']);
    }
    access!; // to tell its not null
    final rollNo = access[Access.rollNo_];
    final token = access[Access.token_];
    return isValid(rollNo, token);
  }

  static String addAccess(String? rollNo) {
    // is valid rollNo
    final err1 = Credential.isValidRollNo(rollNo);
    ApiResponseHandler.ifExistThrowErrors([err1]);

    return addAccessWV(rollNo!);
  }
}
