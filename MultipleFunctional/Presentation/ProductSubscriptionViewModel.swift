//
//  ProductSubscriptionViewModel.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import Foundation
import StoreKit

class ProductSubscriptionViewModel: ObservableObject {
    private let productSubscriptionUseCase: ProductSubscriptionUseCaseType

    init(productSubscriptionUseCase: ProductSubscriptionUseCaseType) {
        self.productSubscriptionUseCase = productSubscriptionUseCase
    }

    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus {
        return productSubscriptionUseCase.status(for: statuses, ids: ids)
    }

    func observeTransactionUpdates() {
        Task {
            productSubscriptionUseCase.observeTransactionUpdates
        }
    }

    func checkForUnfinishedTransactions() {
        Task {
            productSubscriptionUseCase.checkForUnfinishedTransactions
        }
    }
}
