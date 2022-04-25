//imports de package externo

//imports de outra camada
import 'package:manguinho01/domain/helpers/helpers.dart';

import '../../domain/usecases/usecases.dart'; //para o AuthenticationParams
//imports de mesma camada
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJason();
    try {
      return await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch (error) {
      throw (error == HttpError.unauthorizedCredencials)
          ? DomainError.invalidCredencials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;
  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) {
    return RemoteAuthenticationParams(
        email: params.email, password: params.secret);
  }

  Map toJason() => {'email': email, 'password': password};
}
