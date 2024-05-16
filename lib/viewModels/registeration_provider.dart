import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../config/api_config.dart';
import '../config/api_endpoints.dart';
import '../config/custom_dio.dart';

class RegisterProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();
  int _recId = 0;
  bool _status = false;
  int _log_status = 0;
  String _api_token = "";
  String _msg = '';

  int get accessToken => _recId;

  bool get status => _status;

  int get log_status => _log_status;

  String get api_token => _api_token;

  String get msg => _msg;


  Future<void> sendOtp(String mobileNo) async {
    try {

      logger.i("mobileNo--$mobileNo");
      logger.i("sendOtp--${ApiConfig.getBaseUrl('base')}");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getRegisterOtp}',
        // Replace with your API endpoint
        data: {
          'MobileNo':mobileNo,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_status");
          _msg = responseBody['ResultText'];
          logger.i("response--$_msg");
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
  Future<void> resentsendOtpforRegisterAndUserName(String mobileNo,String otpType) async {
    try {
      logger.i("resentsendOtpforRegisterAndUserName-----");
      logger.i("mobileNo--$mobileNo");
      logger.i("otpType--$otpType");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getResentOtpForRegisterOtpandUseName}',
        // Replace with your API endpoint
        data: {
          "OTPType": '$otpType',
          "MobileNo": '$mobileNo'

      },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_status");
          _msg = responseBody['ResultText'];
          logger.i("response--$_msg");
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


  Future<void> signUp(String otp,String userName,String password) async {
    try {

      logger.i("otp--$otp");
      logger.i("userName--$userName");
      logger.i("password--$password");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.registeration}',
        // Replace with your API endpoint
        data: {
          'UserName':userName,
          'Password':password,
          'Otp':otp,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
         final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (resultSet.isNotEmpty) {
           final Map<String, dynamic> resultSetItem = resultSet[0];
          _status = resultSetItem['Status'];
          logger.i("response--$_status");
          _msg = resultSetItem['ResultText'];
          logger.i("response--$_msg");
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

  Future<void> forgotPasswordOtp(String userName) async {
    try {

      logger.i("userName--$userName");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getforgotPasswordOtp}',
        // Replace with your API endpoint
        data: {
          'UserName':userName,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
         // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
           // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_status");
          _msg = responseBody['ResultText'];
          logger.i("response--$_msg");
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
  Future<void> resendforgotPasswordOtp(String userName) async {
    try {
      logger.i("resendforgotPasswordOtp-----");
      logger.i("userName--$userName");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getresendforgotPasswordOtp}',
        // Replace with your API endpoint
        data: {
          "OTPType": "FPQ",
          'UserName':'$userName',

        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_status");
          _msg = responseBody['ResultText'];
          logger.i("response--$_msg");
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

  Future<void> forgotpasswordRest(String otp,String userName,String password) async {
    try {

      logger.i("otp--$otp");
      logger.i("userName--$userName");
      logger.i("NewPassword--$password");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.forgotPasswordReset}',
        // Replace with your API endpoint
        data: {
          'UserName':userName,
          'NewPassword':password,
          'OTP':otp,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (resultSet.isNotEmpty) {
          final Map<String, dynamic> resultSetItem = resultSet[0];
          _status = resultSetItem['Status'];
          logger.i("response--$_status");
          _msg = resultSetItem['ResultText'];
          logger.i("response--$_msg");
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

  Future<void> forgotUsernamesendOtp(String mobileNo) async {
    try {

      logger.i("mobileNo--$mobileNo");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getForgotUserNameOtp}',
        // Replace with your API endpoint
        data: {
          'MobileNo':mobileNo,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_status");
          _msg = responseBody['ResultText'];
          logger.i("response--$_msg");
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

  Future<void> sendUserName(String otp,String userName) async {
    try {

      logger.i("otp--$otp");
      logger.i("userName--$userName");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.sendUserName}',
        // Replace with your API endpoint
        data: {
          'Otp':otp,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_status");
          _msg = responseBody['ResultText'];
          logger.i("response--$_msg");
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

  Future<void> login(String userName,String password,String token) async {
    try {

      logger.i("userName--$userName");
      logger.i("password--$password");
      logger.i("fcmtoken--$token");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.login}',
        // Replace with your API endpoint
        data: {
          'UserName':userName,
          'Password':password,
          'FirebaseToken':token,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        // final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (responseBody.isNotEmpty) {
          // final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = responseBody['Status'];
          logger.i("response--$_log_status");
          _msg = responseBody['StatusMessage'];
          logger.i("response--$_msg");
          _api_token = responseBody['responseToken'];
          logger.i("response--$_api_token");
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
  Future<void> logout(String token) async {
    try {

      logger.i("token--$token");



      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.logout}',
        options: Options(headers: {
          'Authorization': 'Bearer $token',  // Add token to the header
        }),
        // Replace with your API endpoint
        data: {
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode ==
          200) { // Check if the response status code is 200 (OK)
        final Map<String, dynamic> responseBody = response.data;
        final List<dynamic> resultSet = responseBody['ResultSet'];
        logger.i("resultSet--$responseBody");

        if (resultSet.isNotEmpty) {
          final Map<String, dynamic> resultSetItem = resultSet[0];
          _log_status = resultSetItem['Status'];
          logger.i("response--$_log_status");
          _msg = resultSetItem['SaveText'];
          logger.i("response--$_msg");
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
