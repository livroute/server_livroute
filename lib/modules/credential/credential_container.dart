import 'package:onenizam/headers.dart';

class CredentialContainer {
  static DbCollection? get coll => MongoDbFunc.credential;

  static Future<ApiResponse> loginAccount({
    required String? rollno,
    required String? password,
    required String? token,
  }) async {
    // ROll no or Username one should be must
    final err1 = Credential.isValidRollNo(rollno);
    if (password == null && token == null) {
      ApiResponseHandler.ifExistThrowErrors([err1, 'Enter Password or Token']);
    }

    final err2 = password == null ? null : Credential.isValidPassword(password);
    String? err3 = token == null ? null : Access.isValidToken(token);
    // if no error in password then ignore token if token have error
    if (err3 != null && err2 == null) err3 = null;
    ApiResponseHandler.ifExistThrowErrors([err1, err2]);

    return await loginAccountWV(
      rollno!,
      password!,
      token,
    );
  }

  static Future<ApiResponse> loginAccountWV(
    String rollno,
    String password,
    String? token,
  ) async {
    if (token != null) {
      final acess = AccessContianer.isValid(rollno: rollno, token: token);
      if (acess != null) {
        return ApiResponse.successData({Access.token_: token});
      }
    }

    final filter = where.eq(Credential.rollno_, rollno);
    final res = await coll!.findOne(filter);

    if (res != null) {
      if (res[Credential.password_] == password) {
        // Account Logined Successfully
        final newToken = AccessContianer.addAccessWV(
          res[Credential.rollno_],
          res[Credential.securityLevel_] ?? 10,
        );
        return ApiResponse.successData({Access.token_: newToken});
      } else {
        return ApiResponse.fail('Incorrect Password');
      }
    } else {
      return ApiResponse.fail('rollno not register with us');
    }
  }
}
