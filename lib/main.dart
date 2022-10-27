import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_delta/domain/device_info.dart';
import 'package:test_delta/pages/home_page.dart';
import 'package:test_delta/pages/web_widget_page.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("af80b721-594d-4455-b3a7-94c02a1d7c9f");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  final deviceInfo = DeviceInfo(prefs);

  String url = await deviceInfo.getInfo();

  runApp(MaterialApp(
    home: url == "none" || url.isEmpty
        ? const MyHomePage()
        : WebWidgetPage(url: url),
  ));
}
