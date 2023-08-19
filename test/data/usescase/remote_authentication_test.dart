import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:manguinho01/data_layer/http/http.dart';
import 'package:manguinho01/domain/helpers/helpers.dart';
import 'package:mocktail/mocktail.dart';

import 'package:manguinho01/data_layer/usecases/usecases.dart';

import 'package:manguinho01/domain/usecases/usecases.dart';
import 'package:manguinho01/data_layer/http/http_client.dart';

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
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
  });
  test('Should call httpClient with correct URL',() async {
    // Arrange by Setup(system under test)
    
    // act
    await sut.auth(params);

    // Assert - é pra garantir que a url que o request vai receber é a mesma 
    verify(()  {
      return  httpClient.request(
        url: url, 
        method: 'post',
        body: {'email':params.email, 'password':params.secret}
        );
      });
  });
  test('Should call httpClient with correct values',() async {
    // Arrange by Setup(system under test)
   

    // act
    await sut.auth(params);

    // Assert - é pra garantir que a url que o request vai receber é a mesma 
    verify(()=> httpClient.request(
      url: url, 
      method: 'post',
      body: {'email':params.email, 'password':params.secret}));
  });


  test('Should throw unexpected error if HttpClient returns 400',() async {
    // Arrange by Setup(system under test)
    ///Portanto, no contexto do seu teste, o anyNamed('method') está sendo 
    ///usado para garantir que a chamada ao método get inclua um argumento nomeado 
    ///'method', mas não importa qual seja o valor desse argumento. 
    ///Isso permite que você defina o comportamento esperado para a chamada do método, 
    ///independentemente dos cabeçalhos específicos que estão sendo passados.

    when(()=> httpClient.request(url: any(named: 'url'),method: any(named:'method'), body: any(named:'body'))).thenThrow(HttpError.badRequest);

    // act
    final future = sut.auth(params);

    // Assert - é pra garantir que a url que o request vai receber é a mesma 
    expect(future, throwsA(DomainError.unexpected));
  });

  
}