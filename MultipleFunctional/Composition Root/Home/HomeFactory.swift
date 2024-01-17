//
//  HomeFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

class HomeFactory: CreateHomeView {

    func create() -> HomeView {
        return HomeView(viewModelLogin: AuthenticationFactory.sharedLoginViewModel,
                        viewModelProducts: createViewModelProducts(),
                        createShopView: ShopFactory())
    }

    private func createViewModelProducts() -> ProductSubscriptionViewModel {
        return ProductSubscriptionViewModel(productSubscriptionUseCase: createProductSubscriptionUseCase())
    }

    private func createProductSubscriptionUseCase() -> ProductSubscriptionUseCaseType {
        return ProductSubscriptionUseCase.shared
    }
}
