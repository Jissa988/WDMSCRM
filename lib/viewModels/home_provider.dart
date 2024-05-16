import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../config/api_endpoints.dart';
import '../config/custom_dio.dart';
import '../models/homeModel.dart';

class HomeProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();
  int _recId = 0;
  int _status = 0;
  String _msg = '';

  int get accessToken => _recId;
  int get status => _status;
  String get msg => _msg;

  List<CustomerAccouts> _customerAccounts = [];
  CustomerAccouts? _selected_customerAccounts;
  List<CustomerAccouts> get customerAccounts => _customerAccounts;
  CustomerAccouts? get selected_customerAccounts => _selected_customerAccounts;

  set selected_customerAccounts(CustomerAccouts? customerAccouts) {
    print('Setting selected_customerAccounts: ${customerAccouts?.customerName}');
    _selected_customerAccounts = customerAccouts;

    notifyListeners();

  }


  Future<void> fetchCustomerAccounts(String token) async {
    try {
      print("fetchCustomerAccounts--$token");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getCustomerAccounts}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),
        data: {
          // Your request data here
        },
      );
    logger.i("response--${response}");
    logger.i("response--${response.statusCode}");
      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet']; // Access response.data instead of response
        _customerAccounts = data.map((item) => CustomerAccouts(item['CustomerId'], item['CustomerName'])).toList();
        logger.i("_customerAccounts--${_customerAccounts}");

        // if (_customerAccounts.isNotEmpty) {
        //   _selected_customerAccounts = _customerAccounts.first;
        //   _isfirstTime=true;
        // }

        logger.i("_customerAccounts--${_customerAccounts}");

        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
  List<HomeEmployeeDetails> homeEmployeeDetails = [];

  void updateHomeEmployeeDetails(List<HomeEmployeeDetails> details) {
    homeEmployeeDetails = details;
    notifyListeners(); // Notify listeners about the change
  }

  Future<void> getHome(String token,int customerId) async {
    try {
      print("getHome--$customerId");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getHome}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),

        data: {
          'CustomerId':customerId,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) { // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        List<HomeEmployeeDetails> _homeEmployeeDetails = data.map((item) {

          return HomeEmployeeDetails(
            item['CustomerId'] ?? 0,
            item['CustomerName'] ?? "",
            item['AreaName'] ?? "",
            item['RouteName'] ?? "",
            item['PaymentTerm'] ?? "",
            item['TotalOutstanding'] ?? 0.0,
            item['BottleCustody'] ?? 0,
            item['TempBottles'] ?? 0,
            item['Lastsaledatetime'] ?? "",
            item['TotalCustodyAmount'] ?? 0.0,
            item['TotalDispenser'] ?? 0,
            item['TotalOthers'] ?? 0,
            item['TotalAvailableCouponCount'] ?? 0,
            item['RemainingPaidCouponLeafCount'] ?? 0,
            item['RemainingFreeCouponLeafCount'] ?? 0,
            item['UtilizedPaidCouponLeafCount'] ?? 0,
            item['UtilizsedFreeCouponLeafCount'] ?? 0,
            item['ThisMonthSaleAmount'] ?? 0.0,
            item['ThisMonthCollection'] ?? 0.0,
            item['LastCollectionAmount'] ?? 0.0,
            item['UnseenNotificationCount']?? 0,
            item['FinYearId']?? 0,
            item['FilePath']?? "",
            item['FileName']?? "",
            item['LastDOdatetime']?? "",
            item['ThisMonthDOAmount']?? 0.0,
          );
        }).toList();


        homeEmployeeDetails.clear();
        homeEmployeeDetails.addAll(_homeEmployeeDetails);
     updateHomeEmployeeDetails(_homeEmployeeDetails); // Update HomeProvider with the fetched data

        notifyListeners(); // Notify listeners about the change
      }
      else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

// Define a separate function to fetch unseen notifications
  Future<List<UnSeenNotification>> fetchUnSeenNotifications(String token, int customerId) async {
    List<UnSeenNotification> unSeenNotification = [];
    try {
      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getNotificationUnseen}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {
          "CustomerId": customerId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['ResultSet'];
        print('response--$data');
        unSeenNotification = data.map((item) => UnSeenNotification(
          item['NotificationId']?? 0,
          item['Type']?? "",
          item['TypeId']?? 0,
          item['CustomerId']?? 0,
          item['TransactionHeadId']?? 0,
          item['TransactionDocNo']?? "",
          item['AMOUNT']?? 0.0,
          item['FinYearId']?? 0,

        )).toList();
        notifyListeners();
        return unSeenNotification;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
  Future<void> notificationSeenUpdation(String token, int? notificationId) async {
    try {
      logger.i("updateNotificationStatus--$token");
      logger.i("notificationId--$notificationId");
      logger.i("base--${ApiConfig.getBaseUrl('base')}");
      logger.i("api--${ApiEndpoints.notificationStatusUpdation}");
      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.notificationStatusUpdation}',

        options: Options(headers: {
          'Authorization': 'Bearer $token', // Add token to the header
        }),

        // Replace with your API endpoint
        data: {
          "NotificationId": notificationId
        },
      );
      logger.i("response-notificationSeenUpdation-${response}");
      logger.i("response-statusCode-${response.statusCode}");

      if (response.statusCode == 200) {
        // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          final Map<String, dynamic> resultSetItem = resultSet[0];
          _status = resultSetItem['SaveStatus'];
          logger.i("response--$_status");
          _msg = resultSetItem['ResultText'];
          logger.i("response--$_msg");
          _recId = resultSetItem['NewRecId'];
          logger.i("response--$_recId");
        } else {
          throw Exception('ResultSet is empty');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // Handle login failure
    }
  }


}