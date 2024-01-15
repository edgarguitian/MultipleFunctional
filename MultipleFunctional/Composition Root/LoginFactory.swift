//
//  LoginFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

class LoginFactory: CreateLoginView {

    func create() -> LoginView {
        return LoginView(viewModel: AuthenticationFactory.sharedLoginViewModel)
    }
}
