//
//  MultipleFunctionalApp.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 12/1/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        return true
    }
}

@main
struct MultipleFunctionalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            AuthenticationFactory.create()
                .environment(PassStatusModel())
        }
    }
}
