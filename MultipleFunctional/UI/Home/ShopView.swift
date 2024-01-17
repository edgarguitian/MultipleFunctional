//
//  ShopView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import SwiftUI
import StoreKit

struct ShopView: View {
    @Environment(\.passIDs.group) private var passGroupID

    var body: some View {
        SubscriptionStoreView(groupID: passGroupID) {
            SubscriptionShopContent()
        }
        .backgroundStyle(.clear)
        .subscriptionStoreButtonLabel(.multiline)
        .subscriptionStorePickerItemBackground(.thinMaterial)
        .storeButton(.visible, for: .restorePurchases)
    }
}

#Preview {
    ShopFactory().create()
}
