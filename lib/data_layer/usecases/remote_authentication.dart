import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../utilities/utilities.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  
  Future<void> auth(AuthenticationParams params) async {
    // Criou-se o RemoteAP a partir do AuthP e depois converteu pra toJson
    // A conversão para toJson que leva em conta a api
    // Os parametros que vieram do domain são repassados para o request como
    // RemoteAuthenticationParams (ou seja, foram desacoplados). 
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      await httpClient.request(url:url, method: 'post',body: body);
    } on HttpError catch (e) {
      throw e == HttpError.unauthorizedCredencials ?  DomainError.invalidCredencials :  DomainError.unexpected; 
      
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String secret;
  RemoteAuthenticationParams({
    required this.email,
    required this.secret,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
  RemoteAuthenticationParams(email: params.email, secret: params.secret);
  
  Map<String, dynamic> toJson() => JsonConverter.toJson(this);
  
}