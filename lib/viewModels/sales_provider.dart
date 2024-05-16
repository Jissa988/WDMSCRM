import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../config/api_endpoints.dart';
import '../config/custom_dio.dart';
import '../models/saleInvoiceModel.dart';

class SalesProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();


  List<SalesInvoice> salesInvoice = [];
  List<InvoiceCount> invoiceCount = [];


  Future<void> getSalesList(String token,int finyearId,int? customerId,String fromDate,String toDate) async {
    try {
      print("getSalesList--$customerId");
      print("getSalesList--$finyearId");
      print("getSalesList--$fromDate");
      print("getSalesList--$toDate");


      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getSalesInvoiceList}',

        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          "FinYearId": finyearId,
          "FromDate": fromDate,
          "ToDate": toDate,
          "CustomerId": customerId,
          "length": 200,
          "PageIndex": 1
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        final List<dynamic> data1 = response.data['ResultSet1'];
        logger.i("data--${data}");
        logger.i("data1--${data1}");
        List<SalesInvoice> _salesInvoice = data.map((item) {


          return SalesInvoice(
            item['PageNum'] ?? 0,
            item['HeadId'] ?? 0,
              item['StkType'] ?? "",
              item['InvoiceNo'] ?? "",
            item['InvoiceDate'] ?? "",
              item['Dt'] ?? "",
            item['InvoiceTime'] ?? "",
            item['CustomerId'] ?? 0,
            item['CustomerName'] ?? "",
            item['PaymentTermId'] ?? 0,
            item['PaymentTerm'] ?? "",
            item['NetAmount'] ?? 0.0,
            item['Settled'] ?? 0.0,
            item['PaymentStatus'] ?? "",
            item['CreditSaleFlag'] ?? false,
            item['Active'] ?? "",
            item['CreatedBy'] ?? "",
            item['TotalTaxableAmount'] ?? 0.0,
            item['TotalTaxAmount'] ?? 0.0,
            item['ReceiptTypeId'] ?? 0,
            item['ReceiptType'] ?? "",



          );
        }).toList();


        salesInvoice.clear();
        salesInvoice.addAll(_salesInvoice);

List<InvoiceCount> _invoiceCount=data1.map((item){
  return InvoiceCount(
    item['FullPaidCount'] ?? 0,
    item['PartialPaidCount'] ?? 0,
    item['NotPaidCount'] ?? 0,
  );

}).toList();
        invoiceCount.clear();
        invoiceCount.addAll(_invoiceCount);
        notifyListeners();
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
  List<SalesHeadItems> salesHeadItems = [];
  List<SalesItem> salesItem = [];

  Future<void> getSalesDetails(String token,int? invoiceId) async {
    try {
      print("invoiceId--$invoiceId");

      print("url--${ApiConfig.getBaseUrl('wdms')}");

      http://103.151.107.127:655/
      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('wdms')}${ApiEndpoints.getSalesDetails}',
        //   'http://103.151.107.127:655/${ApiEndpoints.getSalesDetails}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          "SalesInvoiceHeadId": invoiceId
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        final List<dynamic> data2 = response.data['ResultSet1'];
        logger.i("response-data-${data}");
        logger.i("response-data2-${data2}");


        List<SalesHeadItems> _salesHeadItems = data.map((item) {


          return SalesHeadItems(
              item['SaleInvoiceHeadId'] ?? 0,
              item['SaleInvoiceDocNo'] ?? "",
              item['Date'] ?? "",
              item['SaleInvoiceTime'] ?? "",
              item['CustomerName'] ?? "",
              item['CustomerId'] ?? 0,
              item['RouteName'] ?? "",
              item['AreaName'] ?? "",
            item['TotalTaxableAmount'] ?? 0.0,
            item['TotalTaxAmount'] ?? 0.0,
            item['NetAmount'] ?? 0.0,

              item['CreatedBy'] ??"",


          );
        }).toList();


        salesHeadItems.clear();
        salesHeadItems.addAll(_salesHeadItems);

        List<SalesItem> _salesItem = data2.map((item) {


          return SalesItem(
              item['StockIssueId'] ?? 0,
              item['RowNum'] ?? 0,
              item['ItemId'] ?? 0,
              item['UnitId'] ?? 0,
              item['ItemCode'] ?? "",
              item['ItemName'] ?? "",
              item['Unit'] ?? "",
              item['ConsumptionQty'] ?? 0.0,
              item['TempQty'] ?? 0.0,
              item['Quantity'] ?? 0.0,
              item['UnitPrice'] ?? 0.0,
              item['Value'] ?? 0.0,
            item['FocQty'] ?? 0.0,
            item['DiscountType'] ?? 0,
            item['DiscType'] ?? "",
            item['DiscountPercent'] ?? 0.0,
            item['DiscountAmount'] ?? 0.0,
            item['TaxId'] ?? 0,
            item['TaxableAmount'] ?? 0.0,
            item['TaxPercent'] ?? 0.0,
            item['TaxAmount'] ?? 0.0,
            item['TotalAmount'] ?? 0.0,
            item['ActiveStatus'] ?? false,

          );
        }).toList();


        salesItem.clear();
        salesItem.addAll(_salesItem);
        notifyListeners();
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // List<SalesItem> doItem = [];

  Future<void> getDoDetails(String token,int? invoiceId) async {
    try {
      print("invoiceId--$invoiceId");

      print("url--${ApiConfig.getBaseUrl('wdms')}");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('wdms')}${ApiEndpoints.getDoDetails}',
        //   'http://103.151.107.127:655/${ApiEndpoints.getSalesDetails}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          "OutBoundDeliveryId": invoiceId
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        final List<dynamic> data2 = response.data['ResultSet1'];
        logger.i("response-data-${data}");
        logger.i("response-data2-${data2}");

        List<SalesHeadItems> _salesHeadItems = data.map((item) {


          return SalesHeadItems(
            item['OutboundDeliveryHeadId'] ?? 0,
            item['OutboundDeliveryDocNo'] ?? "",
            item['OutboundDeliveryDate'] ?? "",
            item['OutboundDeliveryTime'] ?? "",
            item['CustomerName'] ?? "",
            item['CustomerId'] ?? 0,
            item['RouteName'] ?? "",
            item['AreaName'] ?? "",
              item['TotalTaxableAmount'] ?? 0.0,
              item['TotalTaxAmount'] ?? 0.0,
              item['NetAmount'] ?? 0.0,
            item['CreatedBy'] ??"",


          );
        }).toList();


        salesHeadItems.clear();
        salesHeadItems.addAll(_salesHeadItems);


        List<SalesItem> _doItem = data2.map((item) {


          return SalesItem(
            item['StockIssueId'] ?? 0,
            item['RowNum'] ?? 0,
            item['ItemId'] ?? 0,
            item['UnitId'] ?? 0,
            item['ItemCode'] ?? "",
            item['ItemName'] ?? "",
            item['Unit'] ?? "",
            item['ConsumptionQty'] ?? 0.0,
            item['TempQty'] ?? 0.0,
            item['Quantity'] ?? 0.0,
            item['UnitPrice'] ?? 0.0,
            item['Value'] ?? 0.0,
            item['FocQty'] ?? 0.0,
            item['DiscountType'] ?? 0,
            item['DiscType'] ?? "",
            item['DiscountPercent'] ?? 0.0,
            item['DiscountAmount'] ?? 0.0,
            item['TaxId'] ?? 0,
            item['TaxableAmount'] ?? 0.0,
            item['TaxPercent'] ?? 0.0,
            item['TaxAmount'] ?? 0.0,
            item['TotalAmount'] ?? 0.0,
            item['ActiveStatus'] ?? false,

          );
        }).toList();


        salesItem.clear();
        salesItem.addAll(_doItem);
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