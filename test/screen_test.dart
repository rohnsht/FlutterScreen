import 'package:flutter/services.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('np.com.rohanshrestha/screen'),
      (MethodCall methodCall) async {
        if (methodCall.method == "getBrightness") {
          return 0.5;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('np.com.rohanshrestha/screen'),
      null,
    );
  });

  test('getBrightness', () async {
    expect(await FlutterScreen.getBrightness(), 0.5);
  });
}
