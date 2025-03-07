import Flutter
import UIKit
import UserNotifications  // Tambahkan ini
// Diperlukan untuk memanggil FlutterLocalNotificationsPlugin.setPluginRegistrantCallback
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     // Diperlukan agar komunikasi tersedia di action isolate
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    // Membatalkan notifikasi lama setelah reinstall jika belum pernah dilakukan sebelumnya
    if !UserDefaults.standard.bool(forKey: "Notification") {
        UIApplication.shared.cancelAllLocalNotifications()
        UserDefaults.standard.set(true, forKey: "Notification")
    }
    GeneratedPluginRegistrant.register(with: self)
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}


