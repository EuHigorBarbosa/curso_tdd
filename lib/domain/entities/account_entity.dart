class AccountEntity {
  final String token;

  AccountEntity({required this.token});

  ///Criando uma instancia dele mesmo a partir de um factory
  /// Na api a resposta de sucesso a uma requisição de acesso com email e senha é
  /// {'accessToken': 'string', 'name':'string'}.
  factory AccountEntity.fromJson(Map json) =>
      AccountEntity(token: json['accessToken']);
}
