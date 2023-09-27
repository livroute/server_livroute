import 'package:onenizam/headers.dart';

class BusRouteRestApi {
  final _rLike = '/';
  final _rPostLikes = ePostLikes(isPagination: true, isAccess: false);

  Handler get router {
    final app = Router();

    //get the likes of a post
    app.get(_rPostLikes, (Request request,
        String username,
        String serviceCaption,
        String postCaption,
        String limit,
        String skip) async {
      try {
        return await ApiResponseHandler.createRoute(
          () async {
            final likes = await LikesContainer.getLikes(
              postUsername: username,
              serviceCaption: serviceCaption,
              postCaption: postCaption,
              skip: skip,
              limit: limit,
            );
            return ApiResponse.successData(likes);
          },
        );
      } catch (e) {
        return ApiResponseHandler.errorResponse(e);
      }
    });

    // like a post
    app.post(_rLike, (Request request) async {
      try {
        final data = await ApiResponseHandler.data(request);
        return await ApiResponseHandler.createRouteWithAccess(
          username: data[Access.username_],
          token: data[Access.token_],
          routeCreater: () async {
            final errorOnLike = await LikesContainer.addLike(
              username: data[Access.username_],
              serviceCaption: data[Service.serviceCaption_],
              postCaption: data[Like.postCaption_],
              postUsername: data[Like.postUsername_],
            );
            if (errorOnLike == null) {
              return ApiResponse.successData('Successfully Liked the post');
            } else {
              return ApiResponse.fail(errorOnLike);
            }
          },
        );
      } catch (e) {
        return ApiResponseHandler.errorResponse(e);
      }
    });

    // delete like of a post
    app.delete(_rLike, (Request request) async {
      try {
        final data = await ApiResponseHandler.data(request);
        return await ApiResponseHandler.createRouteWithAccess(
          username: data[Access.username_],
          token: data[Access.token_],
          routeCreater: () async {
            final errorOnLike = await LikesContainer.removeLike(
              username: data[Access.username_],
              serviceCaption: data[Service.serviceCaption_],
              postCaption: data[Like.postCaption_],
              postUsername: data[Like.postUsername_],
            );
            if (errorOnLike == null) {
              return ApiResponse.successData('UnLiked post successfully');
            } else {
              return ApiResponse.fail(errorOnLike);
            }
          },
        );
      } catch (e) {
        return ApiResponseHandler.errorResponse(e);
      }
    });

    return app;
  }
}
