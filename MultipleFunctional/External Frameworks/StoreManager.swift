//
//  StoreManager.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 19/1/24.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

@Observable class StoreManager: ObservableObject {
    var products: [Product]
    var purchasedProducts: [Product] = []
    var hasPurchasedProduct: Bool = false
    var updateListenerTask: Task<Void, Error>?
    private let productId: [String: String]

    init() {
        productId = StoreManager.loadProductId()

        products = []

        updateListenerTask = listenForTransactions()

        Task {
            await requestProducts()

            await updateCustomerProductStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    static func loadProductId() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist,
                                                                     format: nil) as? [String: String] else {
            return [:]
        }
        return data
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {

            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    await self.updateCustomerProductStatus()

                    await transaction.finish()
                } catch {

                    print("Transaction failed verification")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {

            let storeProducts = try await Product.products(for: productId.keys)

            for product in storeProducts {
                switch product.type {
                case .nonConsumable:
                    products.append(product)
                default:
                    print("Unknown product")
                }
            }
            await updateCustomerProductStatus()
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func purchase(_ product: Product) async -> Transaction? {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):

                let transaction = try checkVerified(verification)

                await updateCustomerProductStatus()

                await transaction.finish()

                return transaction
            case .userCancelled, .pending:
                return nil
            default:
                return nil
            }
        } catch {
            return nil
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedProducts: [Product] = []

        for await result in Transaction.currentEntitlements {
            do {

                let transaction = try checkVerified(result)

                switch transaction.productType {
                case .nonConsumable:
                    if let product = products.first(where: { $0.id == transaction.productID }) {
                        purchasedProducts.append(product)
                        self.hasPurchasedProduct = true
                    }
                default:
                    break
                }
            } catch {
                print()
            }
        }

        self.purchasedProducts = purchasedProducts

    }

}
