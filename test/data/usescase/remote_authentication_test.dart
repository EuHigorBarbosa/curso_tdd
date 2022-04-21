//imports externos
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
//imports internos ao flutter
import 'package:flutter_test/flutter_test.dart';
//imports outras layers (aí tem que ter endereço completo, não pode usar ../)
import 'package:manguinho01/domain/usecases/usecases.dart';
import 'package:manguinho01/data_layer/http/http.dart';
import 'package:manguinho01/data_layer/usecases/usecases.dart';

//imports mesma layers

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
