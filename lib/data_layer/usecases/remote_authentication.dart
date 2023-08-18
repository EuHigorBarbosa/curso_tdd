import '../../domain/usecases/usecases.dart';
import '../http/http.dart';
import '../utilities/utilities.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  
  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url:url, method: 'post',body: {'email': params.email, 'password':params.secret });
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String secret;
  RemoteAuthenticationParams({
    required this.email,
    required this.secret,
  });
  
  Map<String, dynamic> toJson() => JsonConverter.toJson(this);
  //Map toJson () => {'email': email, 'password': secret};
}