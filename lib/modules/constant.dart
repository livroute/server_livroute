import 'package:onenizam/headers.dart';

String emailRegex = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
RegExp emailSyntax = RegExp(emailRegex);

// String emailRegex = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$';
// RegExp emailSyntax = RegExp(emailRegex);

const List<String> inValidUsernames = [
  "user",
  'register',
  'login',
  'home',
  'search',
  'profile',
  'post',
  'service',
  'onenizam'
];

bool isInValidUsernames(String email) {
  return inValidUsernames.contains(email);
}

String? isValidId(String? id) {
  if (id == null) return 'Please Enter ID';
  if (id.length != 24) return 'Invalid ID';
  return null;
}

String generateRandomCode() {
  final random = Random();
  String code = '';

  for (int i = 0; i < 6; i++) {
    int digit = random.nextInt(10);
    code += digit.toString();
  }

  return code;
}

String captionToUrl(String caption) {
  caption = caption.trim();
  String url = caption.toLowerCase().replaceAll(' ', '_');
  return url;
}

String urlToCaption(String url) {
  url = url.trim();
  List<String> parts = url.split('_');
  for (int i = 0; i < parts.length; i++) {
    parts[i] = parts[i][0].toUpperCase() + parts[i].substring(1);
  }
  String caption = parts.join(' ');
  return caption;
}

String? isValidCaption(String? caption, {String? name}) {
  if (caption == null || caption.isEmpty) {
    return 'Please Enter ${name == null ? 'Caption' : '$name Caption'}(A-Z,a-z,0-9,space).';
  }
  return RegExp(r'^[A-Za-z0-9 ]+$').hasMatch(caption.trim()) == false
      ? "Caption can contain only (A-Z,a-z,0-9,space)"
      : null;
}

String? isValidCaptionUrl(String? url, {String? name}) {
  if (url == null || url.isEmpty) {
    return 'Please Enter ${name == null ? 'Url' : '$name Url'}';
  }
  return RegExp(r'^[A-Za-z0-9][a-z0-9_ ]*$').hasMatch(url) == false
      ? "${name == null ? 'Url' : '$name Url'} can contain only (a-z,0-9,_) and last character can't be '_'"
      : null;
}

List<Map<String, dynamic>> removeIds(List<Map<String, dynamic>> data) {
  for (int i = 0; i < data.length; i++) {
    data[i].remove('_id');
  }
  return data;
}

Map<String, dynamic>? removeId(Map<String, dynamic>? data) {
  if (data != null) data.remove('_id');
  return data;
}

String? isValidLimit(String limit) {
  // TODO: Dont ignore 0
  final l = int.tryParse(limit);
  if (l == null) return 'Invalid Limit';
  if (l < 0 && l != -1) return 'Invalid Limit';
  return null;
}

String? isValidSkip(String skip) {
  final l = int.tryParse(skip);
  if (l == null || l < 0) return 'Invalid Skip';
  return null;
}
