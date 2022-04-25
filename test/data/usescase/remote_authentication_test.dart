//imports externos
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart'; //imports internos ao flutter
import 'package:flutter_test/flutter_test.dart';
//imports outras layers (aí tem que ter endereço completo, não pode usar ../)
import 'package:manguinho01/domain/helpers/helpers.dart';
import 'package:manguinho01/domain/usecases/usecases.dart';

import 'package:manguinho01/data_layer/http/http.dart';
import 'package:manguinho01/data_layer/usecases/usecases.dart';

//imports mesma layers

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClientFake;
  late RemoteAuthentication sut;
  late String url;
  late AuthenticationParams params;
  setUpAll(() {
    registerFallbackValue(HttpClientSpy());
  });

  setUp(() {
    httpClientFake = HttpClientSpy();
    url = faker.internet.httpUrl(); //'http://www.nubank.com.br'; //
    sut = RemoteAuthentication(httpClient: httpClientFake, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });
  test('should call HttpClient with correct URL and values', () async {
    await sut.auth(params);
    //var x = await sut.auth();
    //var y = await httpClientFake.request(url: url);

    verify(() => httpClientFake.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });

  /// Eu entendi que o mocktail simula uma entrada entrada aleatória qualquer e dá como
  /// retorno um um erro. Depois ele gera parametros aleatórios para simular a autenticação.
  /// A autenticação é testada com a entrada e parametros aleatórios e com uma resposta final
  /// forçada para ser httpError.badRequest.
  /// Daí lá no código tem que se houver um erro do tipo httpError, então o programa vai
  /// retornar um erro do tipo DomainError.unexpected. Ou seja: um erro micro dando sentido de
  /// existência a um erro na camada de domínio. Todos os erros na camada de domínio devem
  /// ser provocados por algum erro na camada mais externa. Os erros de dominio são mais
  /// macros enquanto os erros mais externos são mais pulverizados.
  test(
      'should throw UnexpectedError if HttpClient returns 400 (dados inválidos)',
      () async {
    when(() => httpClientFake.request(
            url: any(named: 'url', that: anything),
            method: any(named: 'method', that: anything),
            body: any(named: 'body', that: anything)))
        .thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
