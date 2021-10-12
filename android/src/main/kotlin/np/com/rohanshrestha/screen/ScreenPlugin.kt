package np.com.rohanshrestha.screen

import android.app.Activity
import android.provider.Settings
import android.view.WindowManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenPlugin */
class ScreenPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "np.com.rohanshrestha/screen")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getBrightness" -> getScreenBrightness(result)
            "setBrightness" -> {
                val brightness = call.argument<Double>("brightness")
                setScreenBrightness(brightness!!, result)
            }
            "enableWakeLock" -> {
                val isAwake = call.argument<Boolean>("isAwake")
                enableWakeLock(isAwake!!, result)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }


    private fun getScreenBrightness(result: MethodChannel.Result) {
        if (activity == null)
            throw NoActivityException()

        var brightness = activity!!.window.attributes.screenBrightness.toDouble()
        if (brightness < 0) {
            try {
                brightness = Settings.System.getInt(
                    activity!!.contentResolver,
                    Settings.System.SCREEN_BRIGHTNESS
                ) / 255.0
            } catch (e: Settings.SettingNotFoundException) {
                brightness = 1.0
                e.printStackTrace()
            }
        }
        result.success(brightness)
    }

    private fun setScreenBrightness(brightness: Double, result: MethodChannel.Result) {
        if (activity == null)
            throw NoActivityException()

        val attributes = activity!!.window.attributes
        attributes.screenBrightness = brightness.toFloat()
        activity!!.window.attributes = attributes
        result.success(null)
    }

    private fun enableWakeLock(isAwake: Boolean, result: MethodChannel.Result) {
        if (activity == null)
            throw NoActivityException()

        if (isAwake)
            activity!!.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        else
            activity!!.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        result.success(null)
    }
}

class NoActivityException : Exception("Screen requires a foreground activity")
