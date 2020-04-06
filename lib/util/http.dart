import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

BaseOptions options = new BaseOptions(
  baseUrl: "https://randomuser.me/api/", // change to your API url
  connectTimeout: 10000,
  receiveTimeout: 300000,
  headers: {
    // accept json headers
    "Content-Type": "application/x-www-form-urlencoded",
    'X-Requested-With': 'XMLHttpRequest',
    'Accept': 'application/json',
    'Accept': 'application/vnd.github.v3+json',
  },
  // return the response directly without redirect from LARAVEL framework.
  followRedirects: false,
  // disable HTTP statuses greator than 500
  validateStatus: (status) => status < 500,
);

Response response;

var dio = new Dio(options);

void dioDefaults({String token = ''}) {
  // dio.options.headers['Authorization'] = 'Bearer $token';
  // print(dio.options.headers['Authorization']);
  dio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    // Do something before request is sent
    // options.queryParameters.addAll({'latitude': 0.0, 'longitude': 0.0});
    return options;
    // If you want to resolve the request with some custom data，
    // you can return a `Response` object or return `dio.resolve(data)`.
    // If you want to reject the request with a error message,
    // you can return a `DioError` object or return `dio.reject(errMsg)`
  }, onResponse: (Response response) async {
    // Do something with response data
    print(response);
    if (response.statusCode == 200) {
      print(response.data['data']);
    }
    return response; // continue
  }, onError: (DioError e) async {
    Fluttertoast.showToast(
      msg: "${e.message}",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );

    return e; //continue
  }));
}
