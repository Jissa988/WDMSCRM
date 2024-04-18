import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';




// class CustomHttpClientAdapter extends HttpClientAdapter {
//   @override
//   Future<ResponseBody> fetch(
//       RequestOptions options,
//       Stream<Uint8List>? requestStream,
//       Future? cancelFuture,
//       ) async {
//     try {
//       print('Making request: ${options.uri}');
//       print('Request headers: ${options.headers}');
//       print('Request data: ${options.data}');
//
//       final response = await DefaultHttpClientAdapter().fetch(
//         options,
//         requestStream,
//         cancelFuture,
//       );
//
//       print('Response: ${response.statusCode}');
//       print('Response headers: ${response.headers}');
//       print('Response data: ${await _decodeResponseData(response.stream)}');
//
//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<String> _decodeResponseData(Stream<List<int>> stream) async {
//     final List<int> bytes = await stream.reduce((a, b) => [...a, ...b]);
//     final String decodedData = utf8.decode(bytes);
//     return decodedData;
//   }
//
//   @override
//   void close({bool force = false}) {}
// }
class CustomHttpClientAdapter extends HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
      RequestOptions options,
      Stream<Uint8List>? requestStream,
      Future? cancelFuture,
      ) async {
    try {
      print('${DateTime.now()} com.smartbip.dajla I --> ${options.method} ${options.uri}');
      if (options.headers != null) {
        print('Headers: ${options.headers}');
      }
      if (options.data != null) {
        print('Body: ${options.data}');
      }

      final response = await DefaultHttpClientAdapter().fetch(
        options,
        requestStream,
        cancelFuture,
      );

      print('${DateTime.now()} com.smartbip.dajla I <-- ${response.statusCode} ${options.method} ${options.uri}');
      if (response.headers != null) {
        print('Headers: ${response.headers}');
      }
      if (response.stream != null) {
        print('Response data: ${await _decodeResponseData(response.stream)}');
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _decodeResponseData(Stream<List<int>> stream) async {
    final List<int> bytes = await stream.reduce((a, b) => [...a, ...b]);
    final String decodedData = utf8.decode(bytes);
    return decodedData;
  }

  @override
  void close({bool force = false}) {}
}