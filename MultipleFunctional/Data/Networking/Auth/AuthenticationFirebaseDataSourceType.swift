//
//  AuthenticationFirebaseDataSourceType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation
import FirebaseAuth

protocol AuthenticationFirebaseDataSourceType {
    func logInEmail(credentials: LoginCredentials) async -> Result<UserDTO, HTTPClientError>
    func logInApple(credentials: AuthCredential) async -> Result<UserDTO, HTTPClientError>
    func register(credentials: LoginCredentials) async -> Result<UserDTO, HTTPClientError>
    func getCurrentUser() async -> UserDTO?
    func logOut() async -> Result<Bool, HTTPClientError>
}
