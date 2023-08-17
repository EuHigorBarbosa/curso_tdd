import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manguinho01/data_layer/http/http_client.dart';
import 'package:mocktail/mocktail.dart';

/// Essa classe foi criada para viabilizar o teste. Ela não existia.
/// Ele sabe que ela existe por causa do diagrama inicial. 
class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth() async {
    await httpClient.request(url:url);
  }
}
abstract class HttpClient {
  Future<void>? request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient{}
void main() {
  test('Should call httpClient with correct URL',() async {
    // Arrange(system under test)
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // act
    await sut.auth();

    // Assert - é pra garantir que a url que o request vai receber é a mesma 
    verify(()=> httpClient.request(url: url));
  });
}