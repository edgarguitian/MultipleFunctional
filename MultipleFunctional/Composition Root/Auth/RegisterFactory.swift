//
//  RegisterFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

class RegisterFactory: CreateRegisterView {

    func create() -> RegisterView {
        return RegisterView(viewModel: AuthenticationFactory.sharedLoginViewModel)
    }
}
