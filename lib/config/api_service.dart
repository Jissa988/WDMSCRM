import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'dio_config.dart';

// class ApiService {
//   static Future<Map<String, dynamic>> getRequest(String endpoint) async {
//     final response = await http.get(Uri.parse(endpoint));
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       return responseData;
//     } else {
//       throw Exception('Failed to fetch data');
//     }
//   }
// }
class ApiService {
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final response = await DioConfig.getDio().get(endpoint);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
