import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:okra_distributer/payment/Db/dbhelper.dart';
import 'package:okra_distributer/payment/views/Constant.dart';
import 'package:okra_distributer/payment/views/CustomWidgets/getingAppInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendingDeviceInfo {
  Future<String?> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> sendDeviceData(String user_ID) async {
    final user_id = _getUserID();

    final db = DBHelper();
    final appInfo = Appinfo();
    final appId = await db.getAppId();

    final deviceInfo = await appInfo.getDeviceInfo();

    if (appId == null || user_id == null) {
      print("Error: App ID or User ID is missing.");
      return;
    }

    final url = Uri.parse(Constant.appId);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'app_id': appId.toString(),
        'mobile_name': deviceInfo['mobile_name'],
        'android_version': deviceInfo['android_version'],
        'user_id': user_ID,
      }),
    );

    if (response.statusCode == 200) {
      print("Data sent successfully: ${response.body}");
    } else {
      print("Failed to send data: ${response.body}");
    }
  }
}
