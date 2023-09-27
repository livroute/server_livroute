import 'package:onenizam/headers.dart';
import 'package:onenizam/modules/busroute/bus_route_rest_api.dart';

void main(List<String> arguments) async {
  await MongoDbFunc.connectToMongoDB();

  // Create routes
  final app = Router();

  // Serve static files (optional)
  // app.mount(AppRoutes.)
  app.mount(AppRoutes.credential, CredentialRestApi().router);
  app.mount(AppRoutes.busroute, BusrouteRestApi().router);
  // app.mount(AppRoutes.messaging, MessagingSocketApi().router);

  // Listen for incoming connections
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  withHotreload(() => serve(handler, InternetAddress.anyIPv4, AppRoutes.port));

  print('Server Listening at http://localhost:${AppRoutes.port}/');
}
