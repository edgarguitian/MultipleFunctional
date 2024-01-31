//
//  AuthRepositoryType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation
import FirebaseAuth

protocol AuthRepositoryType {
    func logInEmail(credentials: LoginCredentials) async -> Result<User, Error>
    func logInApple(credentials: AuthCredential) async -> Result<User, MultipleFunctionalDomainError>
    func register(credentials: LoginCredentials) async -> Result<User, Error>
    func getCurrentUser() async -> User?
    func logOut() async -> Result<Bool, MultipleFunctionalDomainError>
}
