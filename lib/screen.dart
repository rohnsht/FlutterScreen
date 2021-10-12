import 'dart:async';

import 'package:flutter/services.dart';

class Screen {
  static const MethodChannel _channel =
      MethodChannel('np.com.rohanshrestha/screen');

  static Future<double?> getBrightness() async {
    final double? value = await _channel.invokeMethod("getBrightness");
    return value;
  }

  static Future<void> setBrightness(double value) async {
    await _channel.invokeMethod("setBrightness", {"brightness": value});
  }

  static Future<void> enableWakeLock(bool isAwake) async {
    await _channel.invokeMethod("enableWakeLock", {"isAwake": isAwake});
  }
}
