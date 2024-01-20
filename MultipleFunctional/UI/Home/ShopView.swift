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
    let privacyUrl = URL(string: Constants.privacyUrl)
    let termsUrl = URL(string: Constants.termsUrl)
    var body: some View {
        if let privacyUrl = privacyUrl, let termsUrl = termsUrl {
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
        } else {
            Text("shopUrlError")
                .bold()
                .font(.body)
                .foregroundColor(.red)
                .padding(.top, 20)
                .accessibilityIdentifier("loginViewErrorMessage")
        }
    }
}

#Preview {
    ShopFactory().create()
}
