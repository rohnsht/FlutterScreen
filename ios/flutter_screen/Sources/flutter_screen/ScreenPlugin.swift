import Flutter
import UIKit

public class ScreenPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "np.com.rohanshrestha/screen",
      binaryMessenger: registrar.messenger()
    )
    let instance = ScreenPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getBrightness":
      getScreenBrightness(result: result)
    case "setBrightness":
      guard let args = call.arguments as? [String: Any],
            let brightness = args["brightness"] as? Double else {
        result(FlutterError(code: "invalid_args", message: "Expected brightness as Double", details: nil))
        return
      }
      setScreenBrightness(brightness: brightness, result: result)
    case "enableWakeLock":
      guard let args = call.arguments as? [String: Any],
            let isAwake = args["isAwake"] as? Bool else {
        result(FlutterError(code: "invalid_args", message: "Expected isAwake as Bool", details: nil))
        return
      }
      enableWakeLock(isAwake: isAwake, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func getScreenBrightness(result: FlutterResult) {
    result(Double(UIScreen.main.brightness))
  }

  private func setScreenBrightness(brightness: Double, result: FlutterResult) {
    UIScreen.main.brightness = CGFloat(brightness)
    result(nil)
  }

  private func enableWakeLock(isAwake: Bool, result: FlutterResult) {
    UIApplication.shared.isIdleTimerDisabled = isAwake
    result(nil)
  }
}
