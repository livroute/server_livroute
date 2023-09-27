import 'package:onenizam/headers.dart';
import 'package:onenizam/modules/busroute/bus_route.dart';

class BusrouteContainer {
  static DbCollection? get coll => MongoDbFunc.busroute;
  static const int slAddBus = 4;

  static Future<Map<String, dynamic>?> getBusroute({
    required String? routeName,
    required String? isSpeacial,
  }) async {
    final err1 = Busroute.isValidRouteName(routeName);
    ApiResponseHandler.ifExistThrowErrors([err1]);

    return _getBusroute(
      routeName: routeName!,
      isSpeacial:
          isSpeacial != null ? bool.tryParse(isSpeacial) ?? false : false,
    );
  }

  static Future<Map<String, dynamic>?> _getBusroute({
    required String routeName,
    required bool isSpeacial,
  }) async {
    final filter = where
        .eq(Busroute.routeName_, routeName)
        .and(where.eq(Busroute.isSpeacial_, isSpeacial))
        .sortBy('_id', descending: true);
    final res = await coll!.findOne(filter);
    return removeId(res);
  }

  static Future<List<Map<String, dynamic>>> getBusroutes({
    required String routeName,
    required String sIsSpeacial,
    required String sLimit,
    required String sSkip,
  }) async {
    final err1 = isValidLimit(sLimit);
    final err2 = isValidLimit(sSkip);
    ApiResponseHandler.ifExistThrowErrors([err1, err2]);

    bool? isSpeacial = bool.tryParse(sIsSpeacial);
    int limit = int.tryParse(sLimit) ?? 10;
    int skip = int.tryParse(sSkip) ?? 0;

    return _getBusroutes(
      routeName: routeName,
      isSpeacial: isSpeacial,
      limit: limit,
      skip: skip,
    );
  }

  static Future<List<Map<String, dynamic>>> _getBusroutes({
    required String routeName,
    required bool? isSpeacial,
    required int limit,
    required int skip,
  }) async {
    final filter = where;
    if (isSpeacial != null) {
      filter
          .eq(Busroute.isSpeacial_, isSpeacial)
          .and(where.match(Busroute.routeName_, routeName));
    } else {
      filter.match(Busroute.routeName_, routeName);
    }
    filter.sortBy('_id', descending: true).limit(limit).skip(skip);

    final res =
        await coll!.find(filter).asyncMap((event) => removeId(event)!).toList();

    return res;
  }

  static Future<String?> addBusroute({
    required String? routeName,
    required String? symbol,
    required bool? isSpeacial,
    required Access access,
  }) async {
    final err1 = Busroute.isValidRouteName(routeName);
    final err2 = symbol == null ? null : Busroute.isValidSymbol(symbol);
    ApiResponseHandler.ifExistThrowErrors([err1, err2]);

    return _addBusroute(
      routeName: routeName!,
      isSpeacial: isSpeacial,
      symbol: symbol,
      access: access,
    );
  }

  static Future<String?> _addBusroute({
    required String routeName,
    required String? symbol,
    required bool? isSpeacial,
    required Access access,
  }) async {
    if (access.securityLevel > slAddBus) {
      return "You are not allowed to perform this action";
    }

    final isExist = await _getBusroute(
        routeName: routeName, isSpeacial: isSpeacial ?? false);
    if (isExist != null) return 'Bus Route already exist';

    final data = Busroute.add(
        dRouteName: routeName, dIsSpeacial: isSpeacial, dSymbol: symbol);
    await coll!.insert(data.toJson());

    return null;
  }
}
