//
//  AuthRepositoryType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

protocol AuthRepositoryType {
    func logIn(credentials: LoginCredentials) async -> Result<User, MultipleFunctionalDomainError>
    func register(credentials: LoginCredentials) async -> Result<User, MultipleFunctionalDomainError>
    func getCurrentUser() async -> User?
    func logOut() async -> Result<Bool, MultipleFunctionalDomainError>
}
