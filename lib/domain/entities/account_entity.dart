class AccountEntity {
  final String token;

  AccountEntity({required this.token});

  ///Criando uma instancia dele mesmo a partir de um factory
  /// Na api a resposta de sucesso a uma requisição de acesso com email e senha é
  /// {'accessToken': 'string', 'name':'string'}.
  /// Essa parte do programa não pode ficar aqui pois ela posssui detalhes específicos
  /// do httpCliente que no caso é o nome accessToken. Temos que fazer um dominio
  /// limpo de httpClient.
  /// Com essa função eu estou convertendo um json vindo de httpClient em um AccountEntity.
  /// Eu devo obter um accountEntity de um conversor de entidades e não de uma parte de
  /// código que me liga com o httpClient.
  /// ======   código refatorado ======
  /// factory AccountEntity.fromJson(Map json) =>
  ///     AccountEntity(token: json['accessToken']);
  /// --> Esse fromJson trazia consigo um acoplamento entre o clientHttp e o domínio, o que é
  /// inaceitável. O Http deve ser desacoplado do domínio.
  ///
  /// O dominio é abstrato. Nele há uma abstração de que o auth retorna um AccountEntity
  /// Ao implementar o UseCase RemoteAuth (utilizando o httpClient) é necessário retornar
  /// um AccountEntity a partir da resposta Map<'accessToken','token'>. Essa conversão não
  /// pode estar no domínio. Então há a necessidade de existir um model que converta a
  /// resposta em Map do httpClient em AccountEntity. Por isso vamos criar o RemoteAccountModel
  /// gerar um
}
