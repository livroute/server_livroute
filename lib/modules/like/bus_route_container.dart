import 'package:onenizam/headers.dart';
import 'package:onenizam/modules/like/bus_route.dart';

class BusRouteContainer {
  static DbCollection? get coll => MongoDbFunc.likes;
  static const int slAddBus = 4;

  static Future<Map<String, dynamic>?> getBusRoute({
    required String? routeName,
    required String? isSpeacial,
  }) async {
    final err1 = BusRoute.isValidRouteName(routeName);
    ApiResponseHandler.ifExistThrowErrors([err1]);

    return _getBusRoute(
      routeName: routeName!,
      isSpeacial:
          isSpeacial != null ? bool.tryParse(isSpeacial) ?? false : false,
    );
  }

  static Future<Map<String, dynamic>?> _getBusRoute({
    required String routeName,
    required bool isSpeacial,
  }) async {
    final filter = where
        .eq(BusRoute.routeName_, routeName)
        .and(where.eq(BusRoute.isSpeacial_, isSpeacial))
        .sortBy('_id', descending: true);
    final res = await coll!.findOne(filter);
    return removeId(res);
  }

  static Future<List<Map<String, dynamic>>> getBusRoutes({
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

    return _getBusRoutes(
      routeName: routeName,
      isSpeacial: isSpeacial,
      limit: limit,
      skip: skip,
    );
  }

  static Future<List<Map<String, dynamic>>> _getBusRoutes({
    required String routeName,
    required bool? isSpeacial,
    required int limit,
    required int skip,
  }) async {
    final filter = where;
    if (isSpeacial != null) {
      filter
          .eq(BusRoute.isSpeacial_, isSpeacial)
          .and(where.match(BusRoute.routeName_, routeName));
    } else {
      filter.match(BusRoute.routeName_, routeName);
    }
    filter.sortBy('_id', descending: true).limit(limit).skip(skip);

    final res =
        await coll!.find(filter).asyncMap((event) => removeId(event)!).toList();

    return res;
  }

  static Future<String?> addBus({
    required String? routeName,
    required bool? isSpeacial,
    required int? securityLevel,
  }) async {
    final err1 = BusRoute.isValidRouteName(routeName);
    ApiResponseHandler.ifExistThrowErrors([err1]);

    return _addBus(
      routeName: routeName!,
      isSpeacial: isSpeacial ?? false,
      securityLevel: securityLevel ?? 10,
    );
  }

  static Future<String?> _addBus({
    required String routeName,
    required bool isSpeacial,
    required int securityLevel,
  }) async {
    if (securityLevel > slAddBus) {
      return "You are not allowed to perform this action";
    }
  }

  static Future<String?> _addLikeWV({
    required String postUsername,
    required String username,
    required String postCaption,
    required String? serviceCaption,
  }) async {
    final isExist = await findLike(
      postUsername: postUsername,
      username: username,
      postCaption: postCaption,
      serviceCaption: serviceCaption,
    );
    if (isExist != null) {
      return 'Like Already Exist';
    }

    // like not exist . good to add in database,
    final like = Like(
      serviceCaption: serviceCaption,
      postUsername: postUsername,
      username: username,
      postCaption: postCaption,
      timestamp: DateTime.now().toUtc().toIso8601String(),
    );

    coll!.insert(like.toJson());

    // add in post as well // this will automatically add in Profile
    PostContainer.addLikeCountWV(
      username: postUsername,
      serviceCaption: serviceCaption,
      postCaption: postCaption,
    );

    return null;
  }

  static Future<String?> removeLike({
    required String? postUsername,
    required String? username,
    required String? postCaption,
    required String? serviceCaption,
  }) async {
    if (serviceCaption == '_') {
      serviceCaption = null;
    }
    final err1 = Credential.isValidUsername(postUsername);
    final err2 = Credential.isValidUsername(username);
    final err3 = isValidCaptionUrl(
      postCaption,
    );

    final err4 =
        serviceCaption == null ? null : isValidCaptionUrl(serviceCaption);
    ApiResponseHandler.ifExistThrowErrors([err1, err2, err3, err4]);

    return _removeLikeWV(
      postUsername: postUsername!,
      username: username!,
      postCaption: postCaption!,
      serviceCaption: serviceCaption,
    );
  }

  static Future<String?> _removeLikeWV({
    required String postUsername,
    required String username,
    required String postCaption,
    required String? serviceCaption,
  }) async {
    final filter = _selectOneLike(
        postUsername: postUsername,
        username: username,
        postCaption: postCaption,
        serviceCaption: serviceCaption);

    final res = await coll!.deleteOne(filter);

    if (res.nRemoved == 0) return 'Like not deleted';

    PostContainer.removeLikeCountWV(
      username: postUsername,
      serviceCaption: serviceCaption,
      postCaption: postCaption,
    );

    return null;
  }

  //get likes of a post using pagination
  static Future<List<Map<String, dynamic>>> getLikes({
    required String skip,
    required String limit,
    required String? postUsername,
    required String? postCaption,
    required String? serviceCaption,
  }) async {
    if (serviceCaption == '_') {
      serviceCaption = null;
    }
    final err1 = Like.isValidPostUsername(postUsername);
    // final err2 = Like.isValidUsername(username);
    final err2 = isValidCaption(postCaption, name: 'post');

    final err3 =
        serviceCaption == null ? null : isValidCaptionUrl(serviceCaption);
    final err4 = isValidLimit(limit);
    final err5 = isValidSkip(skip);
    ApiResponseHandler.ifExistThrowErrors([err1, err2, err3, err4, err5]);

    return _getLikesWV(
      postUsername: postUsername!,
      skip: int.parse(skip),
      limit: int.parse(limit),
      postCaption: postCaption!,
      serviceCaption: serviceCaption,
    );
  }

  static Future<List<Map<String, dynamic>>> _getLikesWV({
    required int skip,
    required int limit,
    required String postUsername,
    required String postCaption,
    required String? serviceCaption,
  }) async {
    final filter = _selectlikesofPost(
      postUsername: postUsername,
      postCaption: postCaption,
      serviceCaption: serviceCaption,
      limit: limit,
      skip: skip,
    );
    final res = await coll!.find(filter).toList();
    return removeIds(res);
  }

  static Future<List<Map<String, dynamic>>> postLikes({
    required String accessUsername,
    required List<Map<String, dynamic>> postList,
  }) async {
    final posts = postList.toList();
    final List<String> usernames = [];
    final List<String> postCaptions = [];
    final List<String?> serviceCaptions = [];

    for (int i = 0; i < posts.length; i++) {
      final username = posts[i][Post.username_];
      final serviceCaption = posts[i][Post.serviceCaption_];
      final postCaption = posts[i][Post.postCaption_];

      if (!usernames.contains(username)) {
        usernames.add(username);
      }

      if (!postCaptions.contains(postCaption)) {
        postCaptions.add(postCaption);
      }

      if (!serviceCaptions.contains(serviceCaption)) {
        serviceCaptions.add(serviceCaption);
      }
    }

    final filter = where
        .eq(Like.username_, accessUsername)
        .and(where.oneFrom(Like.postCaption_, postCaptions))
        .and(where.oneFrom(Like.postUsername_, usernames))
        .and(where.oneFrom(Like.serviceCaption_, serviceCaptions));

    final res = await coll!.find(filter).toList();

    final List<Map<String, dynamic>> postLikes = [];

    for (int i = 0; i < res.length; i++) {
      for (int j = posts.length - 1; j >= 0; j--) {
        if (posts[j][Post.username_] == res[i][Like.postUsername_] &&
            posts[j][Post.serviceCaption_] == res[i][Like.serviceCaption_] &&
            posts[j][Post.postCaption_] == res[i][Like.postCaption_]) {
          postLikes.add(res[i]);
          posts.removeAt(j); // match no need to match again
        }
      }
    }
    return removeIds(postLikes);
  }
}
