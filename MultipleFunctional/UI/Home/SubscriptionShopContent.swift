//
//  SubscriptionShopContent.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 16/1/24.
//

import SwiftUI

struct SubscriptionShopContent: View {
    var body: some View {
        VStack {
            image
            VStack(spacing: 3) {
                title
                desctiption
            }
        }
        .padding(.vertical)
        .padding(.top, 40)
    }
}

#Preview {
    SubscriptionShopContent()
}

extension SubscriptionShopContent {
    @ViewBuilder
    var image: some View {
        Image(systemName: "hare.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
    }

    @ViewBuilder
    var title: some View {
        Text("Unique Subscription")
            .font(.largeTitle.bold())
    }

    @ViewBuilder
    var desctiption: some View {
        Text("Subscription to unlock all the content.")
            .fixedSize(horizontal: false, vertical: true)
            .font(.title3.weight(.medium))
            .padding([.bottom, .horizontal])
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
    }
}
