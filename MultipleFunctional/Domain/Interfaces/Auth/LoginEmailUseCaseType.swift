//
//  LoginEmailUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

protocol LoginEmailUseCaseType {
    func execute(email: String, password: String) async -> Result<User, MultipleFunctionalDomainError>
}
