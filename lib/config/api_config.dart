import 'package:customer_portal/firebase/remoteConfig.dart';


class ApiConfig {
  static Map<String, String> baseUrls = {
    'base': RemoteConfigService().getBaseUrl(),
    'wdms': RemoteConfigService().getBaseUrlWdms(),
    'image': RemoteConfigService().getBaseUrlImageUpload(),

    // development
  };
  // static Map<String, String> baseUrls = {
  //   'base': RemoteConfigService().getQCBaseUrl(),
  //   'wdms': RemoteConfigService().getQCBaseUrlWdms(),
  //   'image': RemoteConfigService().getQCBaseUrlImageUpload(),
  //
  //   // QC
  // };

  static String getBaseUrl(String key) {
    return baseUrls[key] ?? baseUrls['base']!;
  }

}
