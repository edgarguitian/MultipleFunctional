//
//  LoginAppleUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 18/1/24.
//

import Foundation
import FirebaseAuth

protocol LoginAppleUseCaseType {
    func execute(credential: AuthCredential) async -> Result<User, MultipleFunctionalDomainError>
}
