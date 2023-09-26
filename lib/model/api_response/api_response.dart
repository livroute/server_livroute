import '../../../headers.dart';

class ApiResponse {
  final bool success;
  final Payload payload;

  get data => payload.data;

  static const String success_ = 'success';
  static const String payload_ = 'payload';

  ApiResponse({
    required this.success,
    Payload? payload,
  }) : payload = payload ?? Payload();

  ApiResponse.fail(String message)
      : success = false,
        payload = Payload(message: message);

  ApiResponse.successData(dynamic data)
      : success = true,
        payload = Payload(message: '', data: data);

  ApiResponse.success(String message)
      : success = true,
        payload = Payload(
          message: message,
        );

  factory ApiResponse.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ApiResponse(
      success: json[success_] ?? false,
      payload: json[payload_] != null ? Payload.fromJson(json[payload_]) : null,
    );
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json[success_] ?? false,
      payload: json[payload_] != null ? Payload.fromJson(json[payload_]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      success_: success,
      payload_: payload.toJson(),
    };
  }
}

class Payload {
  final String message;
  final dynamic data;

  static const String message_ = 'message';
  static const String data_ = 'data';

  Payload({
    this.message = '',
    dynamic data,
  }) : data = data ?? {};

  factory Payload.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Payload(
      message: json[message_] ?? false,
      data: json[data_] ?? '',
    );
  }

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      message: json[message_] ?? false,
      data: json[data_] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      message_: message,
      data_: data,
    };
  }
}
