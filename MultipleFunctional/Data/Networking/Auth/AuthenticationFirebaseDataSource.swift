//
//  AuthenticationFirebaseDataSource.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationFirebaseDataSource: AuthenticationFirebaseDataSourceType {

    func logIn(credentials: LoginCredentials) async -> Result<UserDTO, HTTPClientError> {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: credentials.email,
                                                              password: credentials.password)

            guard let emailAuthResult = authDataResult.user.email else {
                return .failure(.emptyAuthLoginMail)
            }
            let userDTO = UserDTO(email: emailAuthResult)

            return .success(userDTO)
        } catch let error as HTTPClientError {
            return .failure(error)
        } catch {
            return .failure(.generic)
        }
    }

    func register(credentials: LoginCredentials) async -> Result<UserDTO, HTTPClientError> {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: credentials.email,
                                                                  password: credentials.password)

            guard let emailAuthResult = authDataResult.user.email else {
                return .failure(.emptyAuthLoginMail)
            }
            let userDTO = UserDTO(email: emailAuthResult)

            return .success(userDTO)
        } catch let error as HTTPClientError {
            return .failure(error)
        } catch {
            return .failure(.generic)
        }
    }

    func getCurrentUser() async -> UserDTO? {
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }
        return UserDTO(email: email)
    }

    func logOut() async -> Result<Bool, HTTPClientError> {
        do {
            _ = try Auth.auth().signOut()
            return .success(true)
        } catch let error as HTTPClientError {
            return .failure(error)
        } catch {
            return .failure(.generic)
        }
    }
}