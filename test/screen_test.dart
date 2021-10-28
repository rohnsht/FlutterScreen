import 'package:flutter/services.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const MethodChannel channel = MethodChannel('np.com.rohanshrestha/screen');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == "getBrightness") {
        return 0.5;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getBrightness', () async {
    expect(await FlutterScreen.getBrightness(), 0.5);
  });
}
