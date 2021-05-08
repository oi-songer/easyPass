import 'package:dio/dio.dart';

const String ApiUrl = 'http://121.5.160.8:5000/';

class BackendResponse {
  int code;
  String data;

  BackendResponse({this.code, this.data});
}

class BackendClient {
  static var client = Dio(BaseOptions(baseUrl: ApiUrl));

  static Future<BackendResponse> post(
      String path, Map<String, String> body) async {
    var ret = client.post(path, data: body).then(
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
          data: "无法连接到服务器",
        );
      },
    );
    return ret;
  }
}
