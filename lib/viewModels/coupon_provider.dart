import 'package:customer_portal/config/api_config.dart';
import 'package:customer_portal/config/api_endpoints.dart';
import 'package:customer_portal/models/couponModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/custom_dio.dart';

class CouponProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();


  List<Coupons> coupons = [];

  Future<void> getCoupons(String token, int? customerId) async {
    try {
      print("getCoupons--$customerId");


      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getCouponList}',
        options: Options(headers: {
          'Authorization': 'Bearer $token', // Add token to the header
        }),

        data: {
          "CustomerId": customerId
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        List<Coupons> _coupons = data.map((item) {
          return Coupons(
            item['Book'] ?? "",
            item['SeriesNo'] ?? "",
            item['SerialNo'] ?? "",
            item['Amount'] ?? 0.0,
            item['CouponStatus'] ?? "",
            item['UtilizedStatus'] ?? "",
            item['LeafletsPrice'] ?? 0.0,


          );
        }).toList();


        coupons.clear();
        coupons.addAll(_coupons);

        notifyListeners();
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}