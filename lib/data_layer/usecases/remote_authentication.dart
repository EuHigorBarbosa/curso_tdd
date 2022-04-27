//imports de package externo

//imports de outra camada
import 'package:manguinho01/data_layer/models/models.dart';
import 'package:manguinho01/domain/entities/entities.dart';
import 'package:manguinho01/domain/helpers/helpers.dart';

import '../../domain/usecases/usecases.dart'; //para o AuthenticationParams
//imports de mesma camada
import '../http/http.dart';

/// Uma das funções do caso de uso RemoteAuthentication é converter o dado
/// que vem do httpClient em formato de Map para o formato de account
class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<AccountEntity>? auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJason();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);

      RemoteAccountModel x = RemoteAccountModel.fromJson(httpResponse);
      return x.toEntity();
      //*Daria no mesmo se eu retornasse:
      //*return RemoteAccountModel.fromJson(httpResponse).toEntity();
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
