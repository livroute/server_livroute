import 'package:onenizam/headers.dart';

class Credential {
  final String username;
  final String rollNo;
  final String password;

  static const String username_ = 'username';
  static const String rollNo_ = 'rollno';
  static const String password_ = 'password';

  static String? isValidRollNo(String? e) {
    if (e == null || e.isEmpty) return 'Please enter rollNo';
    //TODO: ADD ROLLNO VALIDATOR
    // if (emailSyntax.hasMatch(e) == false) return 'Invalid rollNo';
    return null;
  }

  static String? isValidUsername(String? u, {String? name}) {
    if (u == null || u.isEmpty) {
      return 'Please enter ${name == null ? 'username' : "$name username"}';
    }
    if (u.length < 3) return 'Username to short';
    if (isInValidUsernames(u)) {
      return "This can't be a ${name == null ? 'username' : "$name username"}";
    }
    return null;
  }

  static String? isValidPassword(String? p) {
    if (p == null || p.isEmpty) return 'Please enter password';
    if (p.length < 8) return 'Password to short';
    return null;
  }

  const Credential({
    required this.username,
    required this.rollNo,
    required this.password,
  });

  factory Credential.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Credential(
      username: json[username_],
      rollNo: json[rollNo_],
      password: json[password_],
    );
  }

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      username: json[username_],
      rollNo: json[rollNo_],
      password: json[password_],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      username_: username,
      rollNo_: rollNo,
      password_: password,
    };
  }

  static Map<String, dynamic> clientSide(
    String token,
    String username,
    String rollNo,
    String password,
  ) {
    return {
      Access.token_: token,
      username_: username,
      rollNo_: rollNo,
      password_: password,
    };
  }
}
