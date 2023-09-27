import 'package:onenizam/headers.dart';

class Credential {
  final String username;
  final String rollno;
  final String password;
  final int securityLevel;

  static const String username_ = 'username';
  static const String rollno_ = 'rollno';
  static const String password_ = 'password';
  static const String securityLevel_ = 'security_level';

  static String? isValidRollNo(String? e) {
    if (e == null || e.isEmpty) return 'Please enter rollno';
    //TODO: ADD ROLLNO VALIDATOR
    // if (emailSyntax.hasMatch(e) == false) return 'Invalid rollno';
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

  static String? isValidSecurityLevel(int? secuirtyLevel) {
    if (secuirtyLevel != null) {
      if (secuirtyLevel < 1 || secuirtyLevel > 10) {
        return 'Invalid Security';
      }
    }
    return null;
  }

  const Credential({
    required this.username,
    required this.rollno,
    required this.password,
    required this.securityLevel,
  });

  factory Credential.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Credential.fromJson(json);
  }

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      username: json[username_],
      rollno: json[rollno_],
      password: json[password_],
      securityLevel: json[securityLevel_],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      username_: username,
      rollno_: rollno,
      password_: password,
    };
  }
}
