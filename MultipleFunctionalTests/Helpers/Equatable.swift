//
//  Equatable.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import Foundation
@testable import MultipleFunctional

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
    }

}
