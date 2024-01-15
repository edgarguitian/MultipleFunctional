//
//  MultipleFunctionalDomainError.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 13/1/24.
//

import Foundation

enum MultipleFunctionalDomainError: Error {
    case generic
    case tooManyRequests
    case emptyAuthLoginMail
    case noUser
}
