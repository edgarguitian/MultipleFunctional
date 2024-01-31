//
//  MultipleFunctionalPresentableErrorMapper.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation
import FirebaseAuth
class MultipleFunctionalPresentableErrorMapper {
    func map(error: MultipleFunctionalDomainError?) -> String {
        guard error == .emptyAuthLoginMail else {
            return NSLocalizedString("errorGeneric", comment: "")
        }

        return "Error on login. Try again later"
    }

    func map(error: NSError?) -> String {
        guard let error = error else {
            return NSLocalizedString("errorGeneric", comment: "")
        }
        switch error.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return NSLocalizedString("errorLoginWrongPassword", comment: "")
        case AuthErrorCode.invalidEmail.rawValue:
            return NSLocalizedString("errorLoginMail", comment: "")
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            return NSLocalizedString("errorLoginExist", comment: "")
        default:
            return NSLocalizedString("errorGeneric", comment: "")
        }
    }
}
