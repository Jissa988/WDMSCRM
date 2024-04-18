import 'package:customer_portal/config/api_config.dart';
import 'package:customer_portal/config/custom_dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../config/api_endpoints.dart';
import '../models/profileModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  final logger = Logger();
  final Dio _dio = CustomDio().createDio();

  int _recId = 0;
  int _status = 0;
  String _stringstatus = "";

  String _api_token = "";
  String _msg = '';
  String _fileName = '';
  String _filePath = '';

  int get accessToken => _recId;

  int get status => _status;

  String get stringstatus => _stringstatus;

  String get api_token => _api_token;

  String get msg => _msg;

  String get fileName => _fileName;

  String get filePath => _filePath;


  List<ProfileDetails> profileDetails = [];

  Future<void> getProfile(String token) async {
    try {
      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.getProfile}',
        options: Options(headers: {
          'Authorization': 'Bearer $token', // Add token to the header
        }),
        data: {},
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

      if (response.statusCode == 200) {
        // Check if the response status code is 200 (OK)
        final List<dynamic> data = response.data['ResultSet'];
        List<ProfileDetails> _profileDetails = data.map((item) {
          return ProfileDetails(
            item['CustomerId'] ?? 0,
            item['CustomerName'] ?? "",
            item['DisplayName'] ?? "",
            item['CustomerType'] ?? "",
            item['CustomerCode'] ?? "",
            item['DOJ'] ?? "",
            item['OfficeAddress'] ?? "",
            item['RouteId'] ?? 0,
            item['RouteName'] ?? "",
            item['AreaId'] ?? 0,
            item['AreaName'] ?? "",
            item['ContactPersonName'] ?? "",
            item['ContactNo'] ?? "",
            item['WhatsAppNo'] ?? "",
            item['EmailId'] ?? "",
            item['SalesExecutive'] ?? "",
            item['CreditLimit'] ?? 0.0,
            item['DeliveryType'] ?? "",
            item['Frequance'] ?? 0,
            item['PaymentTermId'] ?? 0,
            item['PaymentTerm'] ?? "",
            item['BottleCustody'] ?? 0,
            item['CustomerPrice'] ?? 0.0,
            item['UserName'] ?? "",
            item['Password'] ?? "",
            item['ItemName'] ?? "",
            item['ItemPrice'] ?? 0.0,
            item['AnticipateDays'] ?? "",
            item['FilePath'] ?? "",
            item['FileName'] ?? "",
          );
        }).toList();

        profileDetails.clear();
        profileDetails.addAll(_profileDetails);

        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> saveProfileChange(String token,
      String displayName,
      String contactNo,
      String whatsapp,
      String email,
      String userName,
      String password,
      int? customerId) async {
    try {
      logger.i("saveProfileChange--");
      logger.i("displayName--$displayName");
      logger.i("userName--$userName");
      logger.i("password--$password");
      logger.i("token--$token");
      logger.i("contact--$contactNo");
      logger.i("what--$whatsapp");
      logger.i("email--$email");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.updateProfile}',

        options: Options(headers: {
          'Authorization': 'Bearer $token', // Add token to the header
        }),

        // Replace with your API endpoint
        data: {
          'CustomerId': customerId,
          'DisplayName': displayName,
          'ContactNo': contactNo,
          'WhatsAppNo': whatsapp,
          'EmailId': email,
          'Username': userName,
          'Password': password,
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

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

  Future<void> saveProfileimage(String token, int? customerId, String filePath,
      String fileName) async {
    try {
      logger.i("saveProfileimage--");
      logger.i("customerId--$customerId");
      logger.i("filePath--$filePath");
      logger.i("fileName--$fileName");

      final Response<dynamic> response = await _dio.post(
        '${ApiConfig.getBaseUrl('base')}${ApiEndpoints.updateProfilePicture}',

        options: Options(headers: {
          'Authorization': 'Bearer $token', // Add token to the header
        }),

        // Replace with your API endpoint
        data: {
          "CustomerId": customerId,
          "FilePath": filePath,
          "FileName": fileName
        },
      );
      logger.i("response--${response}");
      logger.i("response--${response.statusCode}");

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


  Future<void> uploadImage(String token, pickedFile, int? customerId) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${ApiConfig.getBaseUrl('image')}${ApiEndpoints.uploadImage}'),
      );

      // Add file as a part
      var file = await http.MultipartFile.fromPath(
        'file',
        pickedFile.path,
        filename: pickedFile.name,
      );
      print('file---$file ');

      request.files.add(file);
      print('Request--- $request');

      // Send the request
      var streamedResponse = await request.send();
      print('streamedResponse--- $streamedResponse');

      // Handle response
      var response = await http.Response.fromStream(streamedResponse);
      print('response--$response');

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print('responseBody--$responseBody');

        // Access the first item in the list (assuming there's only one)
        Map<String, dynamic> data = responseBody[0];
        print('data--$data');

        if (data.isNotEmpty) {
          _stringstatus = data['Status'];
          print('responseBody-_boolstatus-$_stringstatus');
          _msg = data['Message'];
          print('responseBody-_msg-$_msg');
          _fileName = data['FileName'];
          print('responseBody-_fileName-$_fileName');
          _filePath = data['FilePath'];
          print('responseBody-_filePath-$_filePath');
        } else {
          throw Exception('ResultSet is empty');
        }
      } else {
        throw Exception('Failed to upload document');
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> deleteImage(String token, String fileName) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.getBaseUrl('image')}${ApiEndpoints.deleteImage}'),
      );
      // Add the filename as a field
      request.fields['FileName'] = fileName;

      // Add token if needed
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      var streamedResponse = await request.send();

      // Handle response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print('responseBody--$responseBody');

        // Access the data directly since it's not an array
        Map<String, dynamic> data = responseBody;
        print('data--$data');

        if (data.isNotEmpty) {
          _stringstatus = data['Status'];
          print('responseBody-_boolstatus-$_stringstatus');
          _msg = data['Message'];
          print('responseBody-_msg-$_msg');
          _fileName = data['FileName'];
          print('responseBody-_fileName-$_fileName');
          _filePath = data['FilePath'];
          print('responseBody-_filePath-$_filePath');
        } else {
          throw Exception('ResultSet is empty');
        }
      } else {
        throw Exception('Failed to delete document');
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> imageView(String token, String fileName) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.getBaseUrl('image')}${ApiEndpoints.imageView}'),
      );
      // Add the filename as a field
      request.fields['FileName'] = fileName;

      // Add token if needed
      request.headers['Authorization'] = 'Bearer $token';

      // Send the request
      var streamedResponse = await request.send();

      // Handle response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        print('responseBody--$responseBody');

        // Access the data directly since it's not an array
        Map<String, dynamic> data = responseBody;
        print('data--$data');

        if (data.isNotEmpty) {
          _stringstatus = data['Status'];
          print('responseBody-_boolstatus-$_stringstatus');
          _msg = data['Message'];
          print('responseBody-_msg-$_msg');

        } else {
          throw Exception('ResultSet is empty');
        }
      } else {
        throw Exception('Failed to delete document');
      }
    } catch (error) {
      // Handle error
    }
  }

}