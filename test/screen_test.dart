import 'package:flutter/services.dart';
import 'package:flutter_screen/flutter_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> methodCalls;

  setUp(() {
    methodCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('np.com.rohanshrestha/screen'),
      (MethodCall methodCall) async {
        methodCalls.add(methodCall);
        if (methodCall.method == "getBrightness") {
          return 0.5;
        } else if (methodCall.method == "setBrightness") {
          return null;
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

  test('getBrightness returns correct value', () async {
    final brightness = await FlutterScreen.getBrightness();
    expect(brightness, 0.5);
    expect(methodCalls, contains(
      isA<MethodCall>().having((call) => call.method, 'method', 'getBrightness'),
    ));
  });

  test('setBrightness calls method with correct brightness value', () async {
    await FlutterScreen.setBrightness(0.8);
    expect(
      methodCalls,
      contains(
        isA<MethodCall>()
            .having((call) => call.method, 'method', 'setBrightness')
            .having(
              (call) => call.arguments,
              'arguments',
              {'brightness': 0.8},
            ),
      ),
    );
  });

  test('setBrightness throws error for invalid values', () async {
    expect(
      () => FlutterScreen.setBrightness(-0.1),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      () => FlutterScreen.setBrightness(1.1),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('resetBrightness restores original brightness', () async {
    // First set brightness to 0.8
    await FlutterScreen.setBrightness(0.8);
    methodCalls.clear();

    // Then reset
    await FlutterScreen.resetBrightness();

    // Verify that setBrightness was called with the original brightness (0.5)
    expect(
      methodCalls,
      contains(
        isA<MethodCall>()
            .having((call) => call.method, 'method', 'setBrightness')
            .having(
              (call) => call.arguments,
              'arguments',
              {'brightness': 0.5},
            ),
      ),
    );
  });
}
