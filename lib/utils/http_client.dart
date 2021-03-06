import 'dart:async';

import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class HttpClient {
  static final HttpClient _instance = new HttpClient._internal();
  Dio dio;
  Dio tokenDio;

  Map<String, String> headers = {
    'x-client-id': 'weapp_wtzz_v1',
    'x-tid': '1',
    'content-type': 'application/json',
  };

  HttpClient._internal() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    tokenDio = Dio(BaseOptions(baseUrl: baseUrl));

//    if (kDebugMode) {
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//          (client) {
//        client.findProxy = (uri) {
//          //proxy all request to localhost:8888
////          return "PROXY 192.168.4.145:8888";
//          return "PROXY 127.0.0.1:8888";
//        };
//      } as dynamic;
//    }

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      var token = await HttpClient.getCache('accessToken');
      if (token != null) {
        options.headers['x-access-token'] = token;
      }
      return options;
    }, onError: (DioError e) async {
      print(e.response.statusCode);
      if (e.response != null && e.response.statusCode == 401) {
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
          return dio.resolve(resp);
        } catch (e) {
          return dio.reject(e);
        }
      } else if (e.response != null &&
          (e.response.statusCode == 422 || e.response.statusCode == 511)) {
        await setCache('accessToken', '');
        await setCache('refreshToken', '');
        goToLogin();
        return dio.resolve(null);
      } else {
        showToast('服务器开小差啦～');
        print(e.response);
        print(e.toString());
        return dio.reject(e);
      }
    }));
  }

  factory HttpClient() => _instance;

  static const baseUrl = 'https://api.ippapp.com/';

  void goToLogin() {
    // go to signin
    final newRouteName = '/login';
    bool isNewRouteSameAsCurrent = false;

    App.navigatorKey.currentState.popUntil((route) {
      print(route.settings.name);
      if (route.settings.name == newRouteName) {
        isNewRouteSameAsCurrent = true;
      }
      return true;
    });

    if (!isNewRouteSameAsCurrent) {
      App.navigatorKey.currentState
          .pushNamedAndRemoveUntil(newRouteName, (_) => false);
    }
  }

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
        }).catchError((error) async {
      dio.interceptors.requestLock.unlock();
      goToLogin();
      await HttpClient.setCache('accessToken', '');
      await HttpClient.setCache('refreshToken', '');
      return;
    });

    await HttpClient.setCache('accessToken', response.data['accessToken']);
    await HttpClient.setCache('refreshToken', response.data['refreshToken']);
  }

  static Future<String> getCache(String key) async {
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
