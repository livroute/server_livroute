import 'package:onenizam/headers.dart';

class AccessContianer {
  static Map<String, Access> data = {};

  static String addAccessWV(String rollno, int securityLevel) {
    print("ADDEDD CALLEDD");
    final t = data[rollno];

    if (t != null) return t.token;
    // else create a new token and return it
    final token = ObjectId().toHexString();
    data[rollno] = Access(
      token: token,
      rollno: rollno,
      securityLevel: securityLevel,
    );

    print('added ${data[rollno]}');

    return token;
  }

  static Access? isValid({required String? rollno, required String? token}) {
    final err1 = Credential.isValidRollNo(rollno);
    final err2 = Access.isValidToken(token);
    ApiResponseHandler.ifExistThrowErrors([err1, err2]);
    return _isValidWV(rollno: rollno!, token: token!);
  }

  static Access? _isValidWV({required String rollno, required String token}) {
    print("DATA $data");
    final access = data[rollno];
    print("HI $access");
    return access == null
        ? null
        : access.token == token
            ? access
            : null;
  }

  static Access? isValidAcess(Map<String, String>? access) {
    if (access == null) {
      ApiResponseHandler.ifExistThrowErrors(['Access Requrired']);
      return null;
    }
    return isValid(
      rollno: access[Access.rollno_],
      token: access[Access.token_],
    );
  }

  static String addAccess({
    required String? rollno,
    required int? securityLevel,
  }) {
    // is valid rollno
    final err1 = Credential.isValidRollNo(rollno);
    ApiResponseHandler.ifExistThrowErrors([err1]);

    return addAccessWV(rollno!, securityLevel ?? 10);
  }

  static int getSecurityLevel(String rollno) {
    final a = data[rollno];
    if (a == null) return 10;

    return a.securityLevel;
  }
}
