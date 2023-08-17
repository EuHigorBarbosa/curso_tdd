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
    await httpClient.request(url:url, method: 'post');
  }
}
abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    });
}

class HttpClientSpy extends Mock implements HttpClient{}
void main() {
  /// O teste garante que a URL passada para o método request() do httpClient seja a mesma que
  ///  foi fornecida ao criar a instância de RemoteAuthentication. Isso evita que erros de
  ///  digitação ou manipulação incorreta de URLs resultem em chamadas de rede para locais errados.
  /// Esse teste usa a função verify para verificar se durante o act houve 
  /// a chamada da função httpClient.request(url: url) com o parametro url pré-definido 
  /// no arrange. A função verify faz isso mesmo, verifica se determinadas funções 
  /// foram chamadas com os argumentos tidos como certos. Existem outras formas de 
  /// verificar com as funções: [verifyNever], [verifyInOrder], [verifyZeroInteractions], and
  /// [verifyNoMoreInteractions].
 
  test('Should call httpClient with correct URL',() async {
    // Arrange(system under test)
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // act
    await sut.auth();

    // Assert - é pra garantir que a url que o request vai receber é a mesma 
    verify(()=> httpClient.request(url: url, method: 'post'));
  });
  test('Should call httpClient with correct value',() async {
    // Arrange(system under test)
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // act
    await sut.auth();

    // Assert - é pra garantir que a url que o request vai receber é a mesma 
    verify(()=> httpClient.request(url: url, method: 'post'));
  });
}