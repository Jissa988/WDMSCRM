import 'package:customer_portal/firebase/remoteConfig.dart';

// class ApiConfig {
//
//   static  String baseUrl = RemoteConfigService().getBaseUrl();
//   static  String baseUrlWdms = RemoteConfigService().getBaseUrlWdms();
//
//
// // Add other global configurations if needed
//
// }
class ApiConfig {
  static Map<String, String> baseUrls = {
    'base': RemoteConfigService().getBaseUrl(),
    'wdms': RemoteConfigService().getBaseUrlWdms(),
    'image': RemoteConfigService().getBaseUrlImageUpload(),

    // Add more base URLs as needed
  };

  static String getBaseUrl(String key) {
    return baseUrls[key] ?? baseUrls['base']!;
  }

}
