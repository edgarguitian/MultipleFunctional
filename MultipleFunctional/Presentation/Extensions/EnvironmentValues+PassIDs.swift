//
//  EnvironmentValues+PassIDs.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import SwiftUI

struct PassIdentifiers {
    var group: String
    var monthly: String
    var yearly: String

}

extension EnvironmentValues {
    private enum PassIDsKey: EnvironmentKey {
        static var defaultValue = PassIdentifiers(
            group: "860D257D",
            monthly: "com.edgar.monthly",
            yearly: "com.edgar.yearly"
        )
    }

    var passIDs: PassIdentifiers {
        get { self[PassIDsKey.self] }
        set { self[PassIDsKey.self] = newValue }
    }
}
