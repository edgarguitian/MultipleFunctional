//
//  HomeFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

class HomeFactory: CreateHomeView {

    func create() -> HomeView {
        return HomeView(viewModel: AuthenticationFactory.sharedLoginViewModel)
    }
}
