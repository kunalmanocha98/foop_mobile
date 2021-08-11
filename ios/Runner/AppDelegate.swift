import UIKit
import Flutter
// import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool
  {
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDWv75mZjT0FoUZE-NxxYqOJ4c4xLZLUhY")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

  }
   override init() {
//    FirebaseApp.configure()
   }
}
