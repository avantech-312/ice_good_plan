import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  private static var apnsToken: String?
  private static var lastPushError: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    let channel = FlutterMethodChannel(name: "app.push_token", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "getPushToken" {
        result(AppDelegate.apnsToken ?? "")
      } else if call.method == "getPushTokenError" {
        result(AppDelegate.lastPushError ?? "")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
      DispatchQueue.main.async {
        application.registerForRemoteNotifications()
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    AppDelegate.apnsToken = token
    AppDelegate.lastPushError = nil
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    AppDelegate.apnsToken = nil
    AppDelegate.lastPushError = error.localizedDescription
  }
}
