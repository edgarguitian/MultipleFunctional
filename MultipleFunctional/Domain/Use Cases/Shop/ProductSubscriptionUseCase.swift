//
//  ProductSubscriptionUseCase.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import Foundation
import OSLog
import StoreKit

final class ProductSubscriptionUseCase: ProductSubscriptionUseCaseType {

    static var shared = ProductSubscriptionUseCase()

    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus {
        let effectiveStatus = statuses.max { lhs, rhs in
            let lhsStatus = PassStatus(
                productID: lhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            let rhsStatus = PassStatus(
                productID: rhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            return lhsStatus < rhsStatus
        }
        guard let effectiveStatus else {
            return .notSubscribed
        }

        let transaction: Transaction
        switch effectiveStatus.transaction {
        case .verified(let transaccion):
            transaction = transaccion
        case .unverified(_, let error):
            print("Error occured in status(for:ids:): \(error)")
            return .notSubscribed
        }

        if case .autoRenewable = transaction.productType {
            if !(transaction.revocationDate == nil && transaction.revocationReason == nil) {
                return .notSubscribed
            }
            if let subscriptionExpirationDate = transaction.expirationDate {
                if subscriptionExpirationDate.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    return .notSubscribed
                }
            }
        }

        return PassStatus(productID: transaction.productID, ids: ids) ?? .notSubscribed
    }

}

extension ProductSubscriptionUseCase {

    func process(transaction verificationResult: VerificationResult<Transaction>) async -> [String] {
        var result: [String] = []

        let transaction: Transaction
        switch verificationResult {
        case .verified(let transaccion):
            result.append("""
            Transaction ID \(transaccion.id) for \(transaccion.productID) is verified
            """)
            transaction = transaccion
        case .unverified(let transaccion, let error):
            result.append("""
            Transaction ID \(transaccion.id) for \(transaccion.productID) is unverified: \(error)
            """)
            return result
        }
        await transaction.finish()
        return result

    }

    func checkForUnfinishedTransactions() async {
        for await transaction in Transaction.unfinished {
            Task.detached(priority: .background) {
                await self.process(transaction: transaction)
            }
        }
    }

    func observeTransactionUpdates() async {
        for await update in Transaction.updates {
            _ = await self.process(transaction: update)
        }
    }
}
