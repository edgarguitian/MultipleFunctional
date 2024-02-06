//
//  RemoteConfiguration.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 6/2/24.
//

import Foundation
import FirebaseRemoteConfig

final class RemoteConfiguration: ObservableObject {
    @Published var showButtonFaceId: Bool = false
    var remoteConfig: RemoteConfig
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(["face_id_activated": true as NSObject])
        showButtonFaceId = remoteConfig.configValue(forKey: "face_id_activated").boolValue
    }
    
    func fetch() {
        remoteConfig.fetchAndActivate { [weak self] success, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.showButtonFaceId = self?.remoteConfig.configValue(forKey: "face_id_activated").boolValue ?? true
            }
        }
    }
}
