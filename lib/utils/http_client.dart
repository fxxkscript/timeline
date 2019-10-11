import 'dart:async';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wshop/screens/app.dart';

class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();
  Dio dio;
  Dio tokenDio;

  Map<String, String> headers = {
    'X-Client-Id': 'weapp_wtzz_v1',
    'X-Tid': '1',
    'Content-Type': 'application/json',
  };

  HttpClient._internal() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    tokenDio = Dio(BaseOptions(baseUrl: baseUrl));

//    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (client) {
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY 172.18.0.16:8888";
//      };
//    } as dynamic;

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var token = await HttpClient.getCache('accessToken');
      if (token != null) {
        options.headers['X-Access-Token'] = token;
      }
      return options;
    }, onError: (DioError e) async {
      if (e.response != null &&
          e.response.statusCode == 401 &&
          e.request.path != 'uc/auth/refreshToken') {
        dio.interceptors.requestLock.lock();
        await refreshToken();
        dio.interceptors.requestLock.unlock();

        try {
          var resp;
          if (e.request.method == 'get') {
            resp = await this.get(e.request.path, e.request.data);
          } else {
            resp = await this.post(e.request.path, e.request.data);
          }
          dio.resolve(resp);
        } catch (e) {
          dio.reject(e);
        }
      } else if (e.response != null &&
          (e.response.statusCode == 422 || e.response.statusCode == 511)) {
        await setCache('accessToken', '');
        await setCache('refreshToken', '');
        // go to signin
        App.navigatorKey.currentState.pushReplacementNamed('/login');
        dio.reject(e);
      } else {
        print(e.toString());
      }

      return e;
    }));
  }

  factory HttpClient() => _instance;

  static const baseUrl = 'https://api.ippapp.com/';

  Future post(String endPoint, [Map<String, dynamic> data = const {}]) async {
    print("post $endPoint $data");

    final response = await this
        .dio
        .post(endPoint, options: Options(headers: headers), data: data);
    print(response);
    var statusCode = response.statusCode;
    print("$statusCode $endPoint ${response.data}");
    return response.data;
  }

  Future get(String endPoint, [Map<String, dynamic> params = const {}]) async {
    print("get $endPoint $params");

    final response = await this.dio.get(endPoint,
        options: RequestOptions(headers: headers, queryParameters: params));
    var statusCode = response.statusCode;
    print("$statusCode $endPoint ${response.data}");
    return response.data;
  }

  Future<void> refreshToken() async {
    String refreshToken = await HttpClient.getCache('refreshToken');

    var response = await this.tokenDio.post('uc/auth/refreshToken',
        options: Options(headers: headers),
        data: {
          'client': {'clientId': 'weapp_wtzz_v1'},
          'authorizationType': 'refresh_token',
          'authDetail': {'refreshToken': refreshToken}
        });

    await HttpClient.setCache('accessToken', response.data['accessToken']);
    await HttpClient.setCache('refreshToken', response.data['refreshToken']);
  }

  static getCache(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static setCache(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
        key, (value != null && value.length > 0) ? value : '');
  }

  static catchRequestError(e) {
    if (e.response is Response) {
      return e.response.data['message'];
    } else {
      return e.message;
    }
  }
}
