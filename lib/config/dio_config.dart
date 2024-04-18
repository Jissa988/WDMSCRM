import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'api_config.dart';
import 'custom_dio.dart';
import 'custom_interceptor.dart';



// class DioConfig {
//   static Dio getDio() {
//     final customDio = CustomDio();
//     final dio = customDio.createDio();
//
//     // Apply interceptor to the dio instance
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         print("--> ${options.method} ${options.uri}");
//         if (options.headers != null) {
//           print("Headers: ${options.headers}");
//         }
//         if (options.data != null) {
//           print("Body: ${options.data}");
//         }
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         print("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}");
//         if (response.headers != null) {
//           print("Headers: ${response.headers}");
//         }
//         if (response.data != null) {
//           print("Response: ${response.data}");
//         }
//         return handler.next(response);
//       },
//       onError: (DioError e, handler) {
//         print("<-- Error: ${e.message}");
//         return handler.next(e);
//       },
//     ));
//
//     dio.options.baseUrl = ApiConfig.baseUrl;
//     dio.options.headers['Content-Type'] = 'application/json';
//     dio.options.validateStatus = (status) {
//       return status! < 500;
//     };
//
//     return dio;
//   }
// }
//
// class DioConfig {
//   static Dio getDio() {
//     final dio = Dio();
//
//     // Apply interceptor to the dio instance
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         print("--> ${options.method} ${options.uri}");
//         if (options.headers != null) {
//           print("Headers: ${options.headers}");
//         }
//         if (options.data != null) {
//           print("Body: ${options.data}");
//         }
//         return handler.next(options);
//       },
//       onResponse: (response, handler) {
//         print("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}");
//         if (response.headers != null) {
//           print("Headers: ${response.headers}");
//         }
//         if (response.data != null) {
//           print("Response: ${json.encode(response.data)}");
//         }
//         return handler.next(response);
//       },
//       onError: (DioError e, handler) {
//         print("<-- Error: ${e.message}");
//         return handler.next(e);
//       },
//     ));
//
//     dio.options.baseUrl = ApiConfig.baseUrl; // Set your base URL
//     dio.options.headers['Content-Type'] = 'application/json';
//     dio.options.validateStatus = (status) {
//       return status! < 500;
//     };
//
//     return dio;
//   }
// }
class DioConfig {
  static Dio getDio({String baseUrlKey = 'base'}) {
    final dio = Dio();

    // Add a custom HttpClientAdapter to access the underlying OkHttp logs
    dio.httpClientAdapter = CustomHttpClientAdapter();

    dio.options.baseUrl = ApiConfig.getBaseUrl(baseUrlKey);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.validateStatus = (status) {
      return status! < 500;
    };

    return dio;
  }
}
