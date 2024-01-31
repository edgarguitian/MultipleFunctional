//
//  User.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

struct User {
    let email: String

    init(email: String) {
        self.email = email
    }

    init(response: UserDTO) {
        self.email = response.email
    }
}
