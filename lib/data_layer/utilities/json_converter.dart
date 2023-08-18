import '../../domain/usecases/usecases.dart';
import '../usecases/usecases.dart';

class JsonConverter {
  static Map<String, dynamic> toJson(dynamic object) {
    if (object is AuthenticationParams) {
      return {
        'email': object.email,
        'password': object.secret,
      };
    }
    if (object is RemoteAuthenticationParams) {
      return {
        'email': object.email,
        'password': object.secret,
      };
    }
    // Você pode adicionar mais casos aqui para outros tipos de objetos

    throw UnsupportedError('Object type not supported for JSON conversion');
  }
}