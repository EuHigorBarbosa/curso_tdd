import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
//import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void>? auth() async {
    return await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void>? request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('should call HttpClient with correct URL', () async {
    final httpClientFake = HttpClientSpy();
    final url = faker.internet.httpUrl(); //'http://www.nubank.com.br'; //
    final sut = RemoteAuthentication(httpClient: httpClientFake, url: url);
    await sut.auth();
    //var x = await sut.auth();
    //var y = await httpClientFake.request(url: url);

    verify(httpClientFake.request(url: url));
  });
}
