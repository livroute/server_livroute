import 'package:onenizam/headers.dart';

class Access {
  final String token;
  final String rollno;
  final int securityLevel;

  static const String access_ = 'access';
  static const String securityLevel_ = 'security_level';
  static const String token_ = 'access_token';
  static const String rollno_ = 'access_rollno';

  static String? isValidToken(String? t) {
    if (t == null || t.isEmpty) return 'Please enter token';
    if (t.length != 24) return 'Invalid Token';
    return null;
  }

  static String? isValidrollno(String? u) {
    if (u == null || u.isEmpty) return 'Please enter rollno';
    if (u.length < 3) return 'rollno to short';
    // if (isInValidRollNos(u)) return "This can't be a rollno";
    return null;
  }

  Access({
    required this.token,
    required this.rollno,
    required this.securityLevel,
  });

  factory Access.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Access.fromJson(json);
  }
  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      token: json[token_] ?? '',
      rollno: json[rollno_] ?? '',
      securityLevel: json[securityLevel_] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      token_: token,
      rollno_: rollno,
    };
  }
}
