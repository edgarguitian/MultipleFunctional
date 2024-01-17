//
//  ProductSubscriptionUseCase.swift
//  MultipleFunctionalTests
//
//  Created by Edgar Guitian Rey on 17/1/24.
//

import XCTest
@testable import MultipleFunctional
import StoreKit
import SwiftLintCore
final class ProductSubscriptionUseCase: XCTestCase {
    
    func test_status_sucessfully_returns_passstatus() async throws {
        // GIVEN
        let useCase = RuleRegistry.shared.productSubscriptionUseCase

        // WHEN
        do {
            let statuses: [Product.SubscriptionInfo.Status] = try await Product.SubscriptionInfo.status(for: "860D257D")
            let ids: PassIdentifiers = PassIdentifiers(group: "860D257D", monthly: "com.edgar.monthly", yearly: "com.edgar.yearly")
            
            // WHEN
            let result = try await useCase.status(for: statuses, ids: ids)
            
            // THEN
            XCTAssertEqual(result, .expectedValue, "La descripción del mensaje en caso de fallo")
        } catch {
            XCTFail("Error inesperado: \(error)")
        }
    }
    
}
