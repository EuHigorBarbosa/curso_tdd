import 'package:manguinho01/domain/entities/entities.dart';

abstract class HttpClient {
  Future<Map> request({
    required String url,
    required String method,
    Map body,
  });
}
