import 'package:customer_portal/config/custom_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../config/api_endpoints.dart';
import '../models/collectionModel.dart';
import '../models/outstandingModel.dart';

class OutstandingProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();


  List<Outstandings> outstandings = [];

  Future<void> getOutstandings(String token,int? customerId) async {
    try {
      print("getSalesList--$customerId");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getOutstandingList}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          "CustomerId": customerId
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        List<Outstandings> _outstandings = data.map((item) {


          return Outstandings(
              item['SLNo'] ?? 0,
              item['InvoiceNo'] ?? "",
              item['InvoiceDate'] ?? "",
              item['InvoiceAmount'] ?? 0.0,
            item['AmountReceived'] ?? 0.0,
              item['BalanceAmount'] ?? 0.0,


          );
        }).toList();


        outstandings.clear();
        outstandings.addAll(_outstandings);

        notifyListeners();
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }


  List<Collections> collections = [];

  Future<void> getCollectionList(String token,int? customerId, String? startDate, String? endDate,int finyearId) async {
    try {
      print("getCollectionList--$customerId");
      print("getCollectionList--$startDate");
      print("getCollectionList--$endDate");
      print("getCollectionList--$finyearId");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getCollections}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          "FinYearId": finyearId,
          "FromDate": startDate,
          "ToDate": endDate,
          "CustomerId": customerId
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        List<Collections> _collections = data.map((item) {


          return Collections(
            item['SNo'] ?? 0,
            item['TypeId'] ?? 0,
            item['FinYearId'] ?? 0,
            item['VoucherId'] ?? 0,
            item['VoucherNo'] ?? "",
            item['VoucherDate'] ?? "",
            item['TransDate'] ?? "",
            item['TransTime'] ?? "",
            item['Amount'] ?? 0.0,
            item['CustomerName'] ?? "",
            item['ReceiptMode'] ?? 0,
            item['ReceiptType'] ?? "",
            item['Active'] ?? false,
            item['CreatedBy']??""




          );
        }).toList();


        collections.clear();
        collections.addAll(_collections);

        notifyListeners();
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }



  List<CollectionItemDetails> collectionItemDetails = [];
  List<CollectionHeaderDetails> collectionHeaderDetails = [];


  Future<void> getCollectionDetails(String token,int? voucherId,int? finyearId,int? typeId) async {
    try {
      print("getCollectionDetails--$voucherId");
      print("getCollectionDetails--$finyearId");
      print("getCollectionDetails--$typeId");


      final Response<dynamic> response = await _dio.post(
         '${ApiConfig.getBaseUrl('wdms')}${ApiEndpoints.getCollectionDetails}',
        // 'http://103.151.107.127:655/${ApiEndpoints.getCollectionDetails}',

        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          "FinYearId": finyearId,
          "VoucherId": voucherId,
          "TypeId": typeId
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data1= response.data['ResultSet'];

        final List<dynamic> data = response.data['ResultSet3'];

        List<CollectionHeaderDetails> _collectionHeaderDetails = data1.map((item) {


          return CollectionHeaderDetails(
            item['VoucherId'] ?? 0,
            item['SlNo'] ?? "",
            item['TransDate'] ?? "",
            item['TransTime'] ?? "",
            item['CustomerId'] ?? 0,
            item['CustomerName'] ?? "",
            item['RouteName'] ?? "",
            item['AreaName'] ?? "",
            item['CreatedBy'] ?? "",
            item['TotalAmount'] ?? 0.0,

          );
        }).toList();


        collectionHeaderDetails.clear();
        collectionHeaderDetails.addAll(_collectionHeaderDetails);

        List<CollectionItemDetails> _collectionItemDetails = data.map((item) {


          return CollectionItemDetails(
            item['InvoiceId'] ?? 0,
            item['StkTrxTypeId'] ?? 0,
            item['DocNo'] ?? "",
            item['DocDt'] ?? "",
            item['DueDt'] ?? "",
            item['ReffDoc'] ?? "",
            item['BillAmt'] ?? 0.0,
            item['Balance'] ?? 0,
            item['Settled'] ?? 0.0,


          );
        }).toList();


        collectionItemDetails.clear();
        collectionItemDetails.addAll(_collectionItemDetails);

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