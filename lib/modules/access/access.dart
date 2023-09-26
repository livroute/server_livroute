import 'package:onenizam/headers.dart';

class Access {
  final String token;
  final String rollNo;

  static const String access_ = 'access';
  static const String token_ = 'token';
  static const String rollNo_ = 'rollno';

  static String? isValidToken(String? t) {
    if (t == null || t.isEmpty) return 'Please enter token';
    if (t.length != 24) return 'Invalid Token';
    return null;
  }

  static String? isValidrollNo(String? u) {
    if (u == null || u.isEmpty) return 'Please enter rollNo';
    if (u.length < 3) return 'rollNo to short';
    // if (isInValidRollNos(u)) return "This can't be a rollNo";
    return null;
  }

  Access({
    required this.token,
    required this.rollNo,
  });

  factory Access.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Access(
      token: json[token_] ?? '',
      rollNo: json[rollNo_] ?? '',
    );
  }
  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      token: json[token_] ?? '',
      rollNo: json[rollNo_] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      token_: token,
      rollNo_: rollNo,
    };
  }
}
