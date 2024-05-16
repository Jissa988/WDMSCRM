import 'dart:io';

import 'package:customer_portal/config/api_config.dart';
import 'package:customer_portal/config/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/custom_dio.dart';
import '../models/bottleModel.dart';
import '../models/materialModels.dart';

class CustodyProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();


  List<Bottles> bottles = [];
  List<BottlesCounts> bottlesCounts = [];
  List<Materials> materials = [];

  Future<void> getBottleDetails(String token, int? customerId) async {
    try {
      print("getBottleDetails--$customerId");


      final Response<dynamic> response = await _dio.post(
         // 'https://wdmsportal.wdms.live:767/${ApiEndpoints.getBottleDetails}',
          '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getBottleDetails}',
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
        final List<dynamic> data1 = response.data['ResultSet'];

        final List<dynamic> data = response.data['ResultSet1'];
        final List<dynamic> data2 = response.data['ResultSet2'];
        List<BottlesCounts> _bottlesCounts = data1.map((item) {
          return BottlesCounts(
            item['BottleCustody'] ?? "",
            item['TempBottleInHand'] ?? "",
            item['BottleInHand'] ?? "",




          );
        }).toList();


        bottlesCounts.clear();
        bottlesCounts.addAll(_bottlesCounts);
        List<Bottles> _bottles = data.map((item) {
          return Bottles(
            item['CustomerId'] ?? 0,
            item['ItemName'] ?? "",
            item['ReffDocNo'] ?? "",
            item['ReffDate'] ?? "",
            item['BottleType'] ?? "",
            item['TrxType'] ?? "",
            item['Amount'] ?? 0.0,
            item['Qty'] ?? 0.0,
            item['CreatedOn'] ?? "",



          );
        }).toList();


        bottles.clear();
        bottles.addAll(_bottles);



        List<Materials> _materials = data2.map((item) {
          return Materials(
            item['CustomerId'] ?? 0,
            item['ItemName'] ?? "",
            item['ReffDocNo'] ?? "",
            item['ReffDate'] ?? "",
            item['IssueType'] ?? "",
            item['TrxType'] ?? "",
            item['Amount'] ?? 0.0,
            item['Qty'] ?? 0.0,
            item['CreatedOn'] ?? "",





          );
        }).toList();


        materials.clear();
        materials.addAll(_materials);



        notifyListeners();
      }
      else {
        throw Exception('Failed to load data');
      }
    }  on DioError catch (e) {
      if (e.type == DioErrorType.other &&
          e.error != null &&
          e.error is SocketException &&
          (e.error as SocketException).osError!.errorCode == 101) {
        // Handle network unreachable error
        throw Exception('Network is unreachable. Please check your internet connection.');
      } else {
        // Handle other Dio errors
        throw Exception('Failed to load data: $e');
      }
    }
  }


  // Future<void> getmaterialDetails(String token, int? customerId) async {
  //   try {
  //     print("getBottleDetails--$customerId");
  //
  //
  //     final Response<dynamic> response = await _dio.post(
  //       '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getMaterialList}',
  //       options: Options(headers: {
  //         'Authorization': 'Bearer $token', // Add token to the header
  //       }),
  //
  //       data: {
  //         "CustomerId": customerId
  //       },
  //     );
  //     logger.i("response--${response}");
  //     logger.i("response--${response.statusCode}");
  //
  //     if (response.statusCode ==
  //         200) { // Check if the response status code is 200 (OK)
  //
  //       final List<dynamic> data = response.data['ResultSet'];
  //       List<Materials> _materials = data.map((item) {
  //         return Materials(
  //           item['Slno'] ?? 0,
  //           item['ItemId'] ?? 0,
  //           item['ItemName'] ?? "",
  //           item['DocNo'] ?? "",
  //           item['MaterialIssueDate'] ?? "",
  //           item['DocDate'] ?? "",
  //           item['Ownership'] ?? "",
  //           item['Quantity'] ?? 0.0,
  //           item['Unit'] ?? "",
  //           item['Price'] ?? 0.0,
  //           item['Amount'] ?? 0.0,
  //           item['VAT'] ?? 0.0,
  //           item['Total'] ?? 0.0,
  //           item['Returned'] ?? 0.0,
  //           item['TrxHeaderId'] ?? 0,
  //
  //
  //
  //
  //         );
  //       }).toList();
  //
  //
  //       materials.clear();
  //       materials.addAll(_materials);
  //
  //
  //       notifyListeners();
  //     }
  //     else {
  //       throw Exception('Failed to load data');
  //     }
  //   }  on DioError catch (e) {
  //     if (e.type == DioErrorType.other &&
  //         e.error != null &&
  //         e.error is SocketException &&
  //         (e.error as SocketException).osError!.errorCode == 101) {
  //       // Handle network unreachable error
  //       throw Exception('Network is unreachable. Please check your internet connection.');
  //     } else {
  //       // Handle other Dio errors
  //       throw Exception('Failed to load data: $e');
  //     }
  //   }
  // }
}