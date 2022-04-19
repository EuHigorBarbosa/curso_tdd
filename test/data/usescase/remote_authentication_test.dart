import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
//import 'package:test/test.dart';
import 'package:manguinho01/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};
    return await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void>? request(
      {required String url, required String method, Map body});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClientFake;
  late RemoteAuthentication sut;
  late String url;
  setUp(() {
    httpClientFake = HttpClientSpy();
    url = faker.internet.httpUrl(); //'http://www.nubank.com.br'; //
    sut = RemoteAuthentication(httpClient: httpClientFake, url: url);
  });
  test('should call HttpClient with correct URL and values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    await sut.auth(params);
    //var x = await sut.auth();
    //var y = await httpClientFake.request(url: url);

    verify(httpClientFake.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });
}
