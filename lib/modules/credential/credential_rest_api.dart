import 'package:onenizam/headers.dart';

class CredentialRestApi {
  CredentialRestApi();

  static const String _eLogin = '/login';

  Handler get router {
    final app = Router();

    app.post(_eLogin, (Request request) async {
      return await ApiResponseHandler.createRoute(() async {
        final data = await ApiResponseHandler.data(request);
        return await CredentialContainer.loginAccount(
          rollNo: data[Credential.rollNo_],
          password: data[Credential.password_],
          token: data[Access.token_],
        );
      });
    });

    return app;
  }
}
