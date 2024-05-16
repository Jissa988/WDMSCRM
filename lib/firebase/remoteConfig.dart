import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {


   final  _remoteConfig = FirebaseRemoteConfig.instance;


  Future<void> initialize() async {
    try {
      await _remoteConfig.setDefaults(<String, dynamic>{
        'welcome_message': 'Welcome to our app!', // Default value
      });

      await _fetchAndActivateRemoteConfig();
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  Future<void> _fetchAndActivateRemoteConfig() async {
    try {
      await _remoteConfig.fetch();
      await _remoteConfig.fetchAndActivate();
      String api_path_wdms = _remoteConfig.getString('API_WDMS');
      String api_path = _remoteConfig.getString('API_PATH');
      String api_path_image = _remoteConfig.getString('API_IMAGE');
      print('api_path_wdms------: $api_path_wdms');

      print('api_path------: $api_path');
      print('api_path_image------: $api_path_image');
      String qcapi_path_wdms = _remoteConfig.getString('QCAPI_WDMS');
      String qcapi_path = _remoteConfig.getString('QCAPI_PATH');
      String qcapi_path_image = _remoteConfig.getString('QCAPI_IMAGE');
      print('qcapi_path_wdms------: $qcapi_path_wdms');

      print('qcapi_path------: $qcapi_path');
      print('qcapi_path_image------: $qcapi_path_image');


    } catch (e) {
      print('Error fetching or activating Remote Config: $e');
    }
  }

  String getQCBaseUrl() {
    print('api_path--1----: ${_remoteConfig.getString('QCAPI_PATH')}');

    return _remoteConfig.getString('QCAPI_PATH');
  }
   String getQCBaseUrlWdms() {
     print('api_path_wdms---1---: ${_remoteConfig.getString('QCAPI_WDMS')}');

     return _remoteConfig.getString('QCAPI_WDMS');
   }
   String getQCBaseUrlImageUpload() {
     print('api_path_image---1---: ${_remoteConfig.getString('QCAPI_IMAGE')}');

     return _remoteConfig.getString('QCAPI_IMAGE');
   }

   String getBaseUrl() {
     print('api_path--1----: ${_remoteConfig.getString('API_PATH')}');

     return _remoteConfig.getString('API_PATH');
   }
   String getBaseUrlWdms() {
     print('api_path_wdms---1---: ${_remoteConfig.getString('API_WDMS')}');

     return _remoteConfig.getString('API_WDMS');
   }
   String getBaseUrlImageUpload() {
     print('api_path_image---1---: ${_remoteConfig.getString('API_IMAGE')}');

     return _remoteConfig.getString('API_IMAGE');
   }

}
