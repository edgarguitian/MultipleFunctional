//
//  ProductSubscriptionUseCaseType.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import Foundation
import StoreKit

protocol ProductSubscriptionUseCaseType {
    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus
    func process(transaction verificationResult: VerificationResult<Transaction>) async
    func checkForUnfinishedTransactions() async
    func observeTransactionUpdates() async
}
