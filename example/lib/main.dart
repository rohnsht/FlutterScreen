import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screen/flutter_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _brightness = 0.0;
  double _sliderBrightness = 0.0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterScreen.enableWakeLock(false);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    double brightness = 0.0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      brightness = await FlutterScreen.getBrightness() ?? 0.0;
    } on PlatformException {
      if (kDebugMode) print("Exception thrown");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _brightness = brightness;
      _sliderBrightness = brightness;
    });

    FlutterScreen.enableWakeLock(true);
  }

  Future<void> _setBrightness() async {
    try {
      await FlutterScreen.setBrightness(_sliderBrightness);
      if (!mounted) return;
      setState(() {
        _brightness = _sliderBrightness;
      });
    } on PlatformException {
      if (kDebugMode) print('Failed to set brightness');
    }
  }

  Future<void> _resetBrightness() async {
    try {
      await FlutterScreen.resetBrightness();
      final double brightness = await FlutterScreen.getBrightness() ?? 0.0;
      if (!mounted) return;
      setState(() {
        _brightness = brightness;
        _sliderBrightness = brightness;
      });
    } on PlatformException {
      if (kDebugMode) print('Failed to reset brightness');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Current brightness: ${_brightness.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Slider(
                  min: 0.0,
                  max: 1.0,
                  value: _sliderBrightness,
                  onChanged: (double value) {
                    setState(() {
                      _sliderBrightness = value;
                    });
                  },
                ),
                Text('Selected: ${_sliderBrightness.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _setBrightness,
                  child: const Text('Set Brightness'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _resetBrightness,
                  child: const Text('Reset Brightness'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
