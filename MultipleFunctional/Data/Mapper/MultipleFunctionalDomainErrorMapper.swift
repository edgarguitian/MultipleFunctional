//
//  MultipleFunctionalDomainErrorMapper.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 13/1/24.
//

import Foundation

class MultipleFunctionalDomainErrorMapper {
    func map(error: HTTPClientError?) -> MultipleFunctionalDomainError {
        guard error == .noUser else {
            return .generic
        }

        return .noUser
    }
}
