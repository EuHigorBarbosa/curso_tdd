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

  //Essa parte do programa tem a ver com permitir que se use any onde os datas tem values.
  setUpAll(() {
    registerFallbackValue(HttpClientSpy());
  });

  Map mockValidDataReceivedFromHttpClient() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  When _mockRequest() => when(() => httpClientFake.request(
      url: any(named: 'url', that: anything),
      method: any(named: 'method', that: anything),
      body: any(named: 'body', that: anything)));

  void mockHttpData(Map data) {
    _mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    _mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClientFake = HttpClientSpy();
    url = faker.internet.httpUrl(); //'http://www.nubank.com.br'; //
    sut = RemoteAuthentication(httpClient: httpClientFake, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('should call HttpClient with correct URL and values', () async {
    ///Eu preciso adicionar um mock de caso de sucesso para que ele não gere uma
    ///exceção ao usar o param mocado que vieram do setup. No setUp eu moco um RemoteAuthentication de nome sut.
    ///Esse sut é utilizado pelo metodo auth(). Se eu não mocar o caso de sucesso (ou seja, se eu não simular que a resposta
    ///a um request utilizando params é um map válido do tipo {'accessToken: 'x': 'name':'y'}) aí então ele vai utilizar o
    ///auth lá do programa. E no programa real, caso não haja uma resposta válida (httpResponse válida) aí gera-se null e cai
    ///no catch por gerar erro de 'null' is not a subtype of Map<dynamic, dynamic> que é a httpREsponse válida. Então tem que mocar o caminho
    ///feliz utilizando:

    mockHttpData(mockValidDataReceivedFromHttpClient());
    //? Tudo isso em azul foi substituido por essas duas funções acima.
    //? when(() => httpClientFake.request(
    //?         url: any(named: 'url', that: anything),
    //?         method: any(named: 'method', that: anything),
    //?         body: any(named: 'body', that: anything)))
    //?     .thenAnswer((_) async =>
    //?         {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    /// Aqui eu simulo que dado um request com url, method e body válidos eu terei uma resposta do tipo MAP, independente
    /// se o programa ainda não estiver com isso implementado.

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
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404 (url inválida)',
      () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'should throw UnexpectedError if HttpClient returns 500 (falha no servidor)',
      () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test(
      'should throw InvalidCredencialsError if HttpClient returns 401 (Unauthorized credentials)',
      () async {
    mockHttpError(HttpError.unauthorizedCredencials);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredencials));
  });

  /// Nesse caso aqui queremos mocar o httpClient para ele retornar não mais um erro mas
  /// sim sucesso com dados. A resposta deve seguir a maneira como a api foi construida.
  /// Na api a resposta de sucesso a uma requisição de acesso com email e senha é
  /// {'accessToken': 'string', 'name':'string'}. O cliente http não retorna um Account
  /// pois ele é uma peça externa ao meu programa.
  ///
  test('should return an Account if HttpClient returns 200', () async {
    final validData = mockValidDataReceivedFromHttpClient();
    mockHttpData(validData);
    final account = await sut.auth(params)!;
    expect(account.token, validData['accessToken']);
    //* A única diferença desse para o debaixo é que aqui eu quero capturar essa parte
    //* do access token.

    //? final accessToken = faker.guid.guid();
    //? Vou deixar como era antes de se fazer a utilização das funções resumo:
    //? when(() =>
    //?     httpClientFake.request(
    //?         url: any(named: 'url', that: anything),
    //?         method: any(named: 'method', that: anything),
    //?         body: any(named: 'body', that: anything))).thenAnswer(
    //?     (_) async => {'accessToken': accessToken, 'name': faker.person.name()});

    //? final account = await sut.auth(params)!;

    //? expect(account.token, accessToken);
  });

  test(
      'should throw UnexpectedError if HttpClent returns 200 with invalid data',
      () async {
    mockHttpData({'invalidKey': 'invalidValue'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
