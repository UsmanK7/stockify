import 'package:device_info_plus/device_info_plus.dart';

class Appinfo {
  Future<Map<String, String>> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return {
      'mobile_name': androidInfo.model ?? 'Unknown',
      'android_version': androidInfo.version.release ?? 'Unknown',
    };
  }
}
