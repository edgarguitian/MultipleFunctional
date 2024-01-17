//
//  PassStatus.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import Foundation
import StoreKit

enum PassStatus: Comparable, Hashable {
    case notSubscribed
    case monthly
    case yearly

    init?(productID: Product.ID, ids: PassIdentifiers) {
        switch productID {
        case ids.monthly: self = .monthly
        case ids.yearly: self = .yearly
        default: return nil
        }
    }

    var description: String {
        switch self {
        case .notSubscribed:
            "Not Subscribed"
        case .monthly:
            "Monthly"
        case .yearly:
            "Yearly"
        }
    }
}
