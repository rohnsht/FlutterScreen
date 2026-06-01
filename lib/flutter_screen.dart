import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterScreen {
  static double? _brightness;

  static const MethodChannel _channel = MethodChannel(
    'np.com.rohanshrestha/screen',
  );

  static Future<double?> getBrightness() async {
    try {
      final double? value = await _channel.invokeMethod("getBrightness");
      return value;
    } on PlatformException catch (e) {
      debugPrint('Error getting brightness: ${e.message}');
      return null;
    }
  }

  static Future<void> setBrightness(double value) async {
    if (value < 0.0 || value > 1.0) {
      throw ArgumentError('Brightness must be between 0.0 and 1.0');
    }
    try {
      _brightness = await getBrightness();
      await _channel.invokeMethod("setBrightness", {"brightness": value});
    } on PlatformException catch (e) {
      _brightness = null;
      debugPrint('Error setting brightness: ${e.message}');
      rethrow;
    }
  }

  static Future<void> resetBrightness() async {
    if (_brightness == null) {
      return;
    }
    try {
      await _channel.invokeMethod("setBrightness", {"brightness": _brightness});
    } on PlatformException catch (e) {
      debugPrint('Error resetting brightness: ${e.message}');
      rethrow;
    }
  }

  static Future<void> enableWakeLock(bool isAwake) async {
    try {
      await _channel.invokeMethod("enableWakeLock", {"isAwake": isAwake});
    } on PlatformException catch (e) {
      debugPrint('Error setting wake lock: ${e.message}');
      rethrow;
    }
  }
}
