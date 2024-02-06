//
//  Tracker.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 6/2/24.
//

import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

final class Tracker {
    static func trackEvent(nameEvent: String, parameters: [String: Any]) {
        Analytics.logEvent(nameEvent, parameters: parameters)
    }
    
    static func recordCrash(nameCrash: String, message: String) {
        let error = NSError(domain: nameCrash, code: 0, userInfo: ["message": message])
        Crashlytics.crashlytics().record(error: error)
    }
}
