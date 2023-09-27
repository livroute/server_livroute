import 'package:onenizam/headers.dart';
import 'package:onenizam/modules/busroute/bus_route_container.dart';

import 'bus_route.dart';

class BusrouteRestApi {
  final _rBusroute = '/';
  // final _rPostLikes = ePostLikes(isPagination: true, isAccess: false);

  Handler get router {
    final app = Router();

    // //get the likes of a post
    // app.get(_rPostLikes, (Request request,
    //     String username,
    //     String serviceCaption,
    //     String postCaption,
    //     String limit,
    //     String skip) async {
    //   try {
    //     return await ApiResponseHandler.createRoute(
    //       () async {
    //         final likes = await LikesContainer.getLikes(
    //           postUsername: username,
    //           serviceCaption: serviceCaption,
    //           postCaption: postCaption,
    //           skip: skip,
    //           limit: limit,
    //         );
    //         return ApiResponse.successData(likes);
    //       },
    //     );
    //   } catch (e) {
    //     return ApiResponseHandler.errorResponse(e);
    //   }
    // });

    // like a post
    app.post(_rBusroute, (Request request) async {
      try {
        final data = await ApiResponseHandler.data(request);
        return await ApiResponseHandler.createRouteWithAccess(
          rollno: data[Access.rollno_],
          token: data[Access.token_],
          routeCreater: (access) async {
            final errorOnLike = await BusrouteContainer.addBusroute(
              routeName: data[Busroute.routeName_],
              symbol: data[Busroute.symbol_],
              isSpeacial: data[Busroute.isSpeacial_],
              access: data[Access.securityLevel_],
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

    return app;
  }
}
