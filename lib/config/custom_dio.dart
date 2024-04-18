import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';


import 'package:dio/dio.dart';
import 'dart:io';

import 'api_config.dart';

class CustomDio {
  Dio createDio() {
    final dio = Dio();

    // Setup HttpClient to accept self-signed certificates
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    //     return true; // Accept self-signed certificates
    //   };
    // };

    return dio;
  }
}
