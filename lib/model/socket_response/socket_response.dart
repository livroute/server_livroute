import '../../../../headers.dart';

class SocketResponse {
  final String action;
  final dynamic data;

  static const String action_ = 'action';
  static const String data_ = 'data';

  SocketResponse({
    required this.action,
    dataa,
  }) : data = dataa ?? {};

  static String get inValidAccess =>
      json.encode(SocketResponse(action: 'INVALID-ACCESS').toJson());

  static String get inValid =>
      json.encode(SocketResponse(action: 'INVALID').toJson());

  factory SocketResponse.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return SocketResponse.fromJson(json);
  }

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    return SocketResponse(
      action: json[action_] ?? '',
      dataa: json[data_] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    if (data == {} || data == null) {
      return {
        action_: action,
      };
    }
    return {
      action_: action,
      data_: data,
    };
  }
}
