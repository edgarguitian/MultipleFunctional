//
//  MultipleFunctionalApp.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 12/1/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCrashlytics
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
          print("Setting up Firebase emulator localhost:8080")
          let settings = Firestore.firestore().settings
          settings.host = "localhost:8080"
          settings.cacheSettings = MemoryCacheSettings()
          settings.isSSLEnabled = false
          Firestore.firestore().settings = settings
        }
        Crashlytics.crashlytics().setUserID("UserID")
        return true
    }
}

@main
struct MultipleFunctionalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var remoteConfiguration = RemoteConfiguration()
    
    var body: some Scene {
        WindowGroup {
            AuthenticationFactory.create()
                .environment(PassStatusModel())
                .environment(StoreManager())
                .environmentObject(remoteConfiguration)
        }
    }
}
