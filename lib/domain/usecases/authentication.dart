import '../../data_layer/utilities/json_converter.dart';
import '../entities/entities.dart';

// abstract class Authentication {
  
//   Future<AccountEntity>? auth({required email,
//     required secret});
// }




abstract class Authentication {
  Future<AccountEntity>? auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String email;
  final String secret;
  AuthenticationParams({
    required this.email,
    required this.secret,
  });
  Map<String, dynamic> toJson() => JsonConverter.toJson(this);
  //Map toJson () => {'email': email, 'password': secret};
}
