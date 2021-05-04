import 'package:dio/dio.dart';

const String ApiUrl = 'http://121.5.160.8:5000/';

class BackendResponse {
  int code;
  String data;

  BackendResponse({this.code, this.data});
}

class BackendClient {
  static var client = Dio(BaseOptions(baseUrl: ApiUrl));

  static Future<BackendResponse> post(Map<String, String> body) async {
    var ret = client.post('/user/login', queryParameters: body).then(
      (response) {
        return BackendResponse(
          code: response.statusCode,
          data: response.data.toString(),
        );
      },
      onError: (e) {
        print(e);
        return BackendResponse(
          code: 408,
          data: "Can't connect to server",
        );
      },
    );
    return ret;
  }
}
