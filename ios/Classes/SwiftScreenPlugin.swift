import Flutter
import UIKit

public class SwiftScreenPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "np.com.rohanshrestha/screen", binaryMessenger: registrar.messenger())
    let instance = SwiftScreenPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     switch call.method{
            case "getBrightness":
                self.getScreenBrightness(result: result)
                break
            case "setBrightness":
                guard let args = call.arguments as? [String: Any] else{
                    break
                }
                let brightness = args["brightness"] as! Double
                self.setScreenBrightness(brightness: brightness, result: result)
                break
            case "enableWakeLock":
                guard let args = call.arguments as? [String: Any] else{
                    break
                }
                let isAwake = args["isAwake"] as! Bool
                self.enableWakeLock(isAwake: isAwake, result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
            }
  }

  private func getScreenBrightness(result: FlutterResult){
        result(Double(UIScreen.main.brightness))
    }
    
    private func setScreenBrightness(brightness: Double, result: FlutterResult){
        UIScreen.main.brightness = CGFloat(brightness)
        result(nil)
    }
    
    private func enableWakeLock(isAwake: Bool, result: FlutterResult){
        UIApplication.shared.isIdleTimerDisabled = isAwake
        result(nil)
    }
}
