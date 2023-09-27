import 'package:onenizam/headers.dart';

class BusRoute {
  final String routeName;
  final bool isSpeacial;
  final String symbol;

  static const String isSpeacial_ = 'is_speacial';
  static const String routeName_ = 'route_name';
  static const String symbol_ = 'symbol';

  static String? isValidRouteName(String? routeName) {
    if (routeName == null) return 'Please Enter Bus Route Name';
    if (routeName.length < 3) return 'Bus Route name too small';
    return null;
  }

  static String? isValidSymbol(String? symbol) {
    if (symbol == null) return 'Please Enter Bus Route symbol';
    symbol = symbol.trim();
    if (symbol.length > 3) return 'Bus Route symbol too large';
    return null;
  }

  BusRoute({
    required this.routeName,
    required this.isSpeacial,
    required this.symbol,
  });

  // json decode and extract values from json map
  factory BusRoute.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return BusRoute.fromJson(json);
  }
  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      isSpeacial: json[isSpeacial_] ?? false,
      routeName: json[routeName_],
      symbol: json[symbol_],
    );
  }

  // extract the values from json map
  Map<String, dynamic> toJson() {
    return {
      isSpeacial_: isSpeacial,
      routeName_: routeName,
      symbol_: symbol,
    };
  }
}
