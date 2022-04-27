import 'package:manguinho01/data_layer/http/http.dart';
import 'package:manguinho01/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    } else {
      return RemoteAccountModel(json['accessToken']);
    }
  }

  AccountEntity toEntity() => AccountEntity(token: accessToken);
}
