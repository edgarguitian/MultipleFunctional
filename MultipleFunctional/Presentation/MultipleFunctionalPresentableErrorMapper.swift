//
//  MultipleFunctionalPresentableErrorMapper.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

class MultipleFunctionalPresentableErrorMapper {
    func map(error: MultipleFunctionalDomainError?) -> String {
        guard error == .emptyAuthLoginMail else {
            return "Something went wrong"
        }

        return "Error on login. Try again later"
    }
}
