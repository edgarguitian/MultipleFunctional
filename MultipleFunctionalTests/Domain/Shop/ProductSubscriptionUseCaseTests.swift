//
//  ProductSubscriptionUseCaseTests.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import XCTest
@testable import MultipleFunctional
import StoreKit
import OSLog

final class ProductSubscriptionUseCaseTests: XCTestCase {

    func test_status_sucessfully_returns_passstatus() async throws {
        // GIVEN
        let useCase = ProductSubscriptionUseCase.shared

        // WHEN
        do {
            let statuses: [Product.SubscriptionInfo.Status] = try await Product.SubscriptionInfo.status(for: "860D257D")
            let ids: PassIdentifiers = PassIdentifiers(group: "860D257D",
                                                       monthly: "com.edgar.monthly",
                                                       yearly: "com.edgar.yearly")

            // WHEN
            let result = useCase.status(for: statuses, ids: ids)

            // THEN
            switch result {
            case .monthly:
                XCTAssertEqual(result, .monthly, "No hay una suscripcion activa")
            case .yearly:
                XCTAssertEqual(result, .yearly, "No hay una suscripcion activa")
            case .notSubscribed:
                XCTAssertEqual(result, .notSubscribed, "Hay una suscripcion activa")
            }
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }

    func test_process_successfully() async {
        // GIVEN
        var mockLogger: [String] = []
        let numTransactions = TestCounter()
        let useCase = ProductSubscriptionUseCase()

        // WHEN
        await withTaskGroup(of: [String].self) { group in
                for await transaction in Transaction.unfinished {
                    numTransactions.increment()
                    group.addTask {
                        return await useCase.process(transaction: transaction)
                    }
                }

                for await logs in group {
                    mockLogger.append(contentsOf: logs)
                }
            }

        // THEN
        XCTAssertEqual(mockLogger.count, numTransactions.load(), "Expected \(numTransactions.load()) log messages")
    }

}

class TestCounter {
    private var value: Int = 0
    private var lock = os_unfair_lock()

    func increment() {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        value += 1
    }

    func load() -> Int {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return value
    }
}
