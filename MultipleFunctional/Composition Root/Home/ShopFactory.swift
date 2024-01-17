//
//  ShopFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import Foundation

class ShopFactory: CreateShopView {
    func create() -> ShopView {
        return ShopView()
    }
}
