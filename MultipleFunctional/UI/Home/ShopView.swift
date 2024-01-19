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
    let privacyUrl = URL(string: "https://github.com/edgarguitian")!
    let termsUrl = URL(string: "https://github.com/edgarguitian")!
    var body: some View {
        SubscriptionStoreView(groupID: passGroupID) {
            SubscriptionShopContent()
        }
        .backgroundStyle(.clear)
        .subscriptionStoreButtonLabel(.multiline)
        .subscriptionStorePickerItemBackground(.thinMaterial)
        .storeButton(.visible, for: .restorePurchases)
        .storeButton(.visible, for: .redeemCode)
        .subscriptionStorePolicyDestination(url: privacyUrl, for: .privacyPolicy)
        .subscriptionStorePolicyDestination(url: termsUrl, for: .termsOfService)
    }
}

#Preview {
    ShopFactory().create()
}
