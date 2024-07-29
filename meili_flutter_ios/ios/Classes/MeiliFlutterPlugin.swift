import Flutter
import UIKit
import MeiliSDK

public class MeiliFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "meili_flutter_ios", binaryMessenger: registrar.messenger())
    let instance = MeiliFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS")
  }
}
