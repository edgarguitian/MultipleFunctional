//
//  HomeView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import SwiftUI
import StoreKit

struct HomeView: View {
    @ObservedObject private var viewModelLogin: LoginViewModel
    @ObservedObject private var viewModelSubscriptions: ProductSubscriptionViewModel

    private let createShopView: CreateShopView
    @State private var showScriptionView: Bool = false
    @State private var presentingSubscriptionSheet = false
    @State private var isPro = false
    @State private var status: EntitlementTaskState<PassStatus> = .loading
    @Environment(\.passIDs) private var passIDs
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel

    init(viewModelLogin: LoginViewModel,
         viewModelSubscriptions: ProductSubscriptionViewModel,
         createShopView: CreateShopView) {
        self.viewModelLogin = viewModelLogin
        self.viewModelSubscriptions = viewModelSubscriptions
        self.createShopView = createShopView
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("welcome \(viewModelLogin.user?.email ?? "No user")")
                    .padding(.top, 32)
                    .accessibilityIdentifier("titleHomeView")
                Spacer()

                List {
                    Section {
                        planView

                        if passStatusModel.passStatus == .notSubscribed {
                            Button {
                                showScriptionView.toggle()
                            } label: {
                                Text("viewSubsOptions")
                                    .foregroundStyle(Color.blue)
                            }
                            .accessibilityIdentifier("btnShopHomeView")
                        }
                    } header: {
                        Text("SUBSCRIPTION")
                    } footer: {
                        if passStatusModel.passStatus != .notSubscribed {
                            Text("Unique Subscription Plan: " +
                                 "\(String(describing: passStatusModel.passStatus.description))")

                        }
                    }

                    Section {
                        ProductView(id: "com.edgar.productconsumable") {
                            Image(systemName: isPro ? "crown.fill" : "crown")
                        }
                        .onInAppPurchaseStart { product in
                            print("User has started buying \(product.id)")
                        }
                        .onInAppPurchaseCompletion { product, result in
                            if case .success(.success(let transaction)) = result {
                                print("Purchased successfully: \(transaction.signedDate)")
                            } else {
                                print("Something else happened")
                            }
                        }
                        .storeButton(.visible, for: .restorePurchases)
                        .productViewStyle(.compact)
                        .padding()
                    } header: {
                        Text("PRODUCT")
                    }
                }
                .sheet(isPresented: $showScriptionView, content: {
                    createShopView.create()
                })

                Spacer()

            }

            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("homeTitle")
            .toolbar {
                Button("Logout") {
                    viewModelLogin.logOut()
                }
                .accessibilityIdentifier("btnLogout")
            }
        }
        .manageSubscriptionsSheet(
            isPresented: $presentingSubscriptionSheet,
            subscriptionGroupID: passIDs.group
        )
        .storeProductTask(for: "com.edgar.productconsumable") { taskState in
                        print(taskState.product?.displayName)
                    }
        .currentEntitlementTask(for: "com.edgar.productconsumable") { taskState in
                        if let verification = taskState.transaction,
                           let transaction = try? verification.unsafePayloadValue {
                            isPro = transaction.revocationDate == nil
                        } else {
                            isPro = false
                        }
                    }
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            self.status = taskStatus.map { statuses in
                viewModelSubscriptions.status(
                    for: statuses,
                    ids: passIDs
                )
            }
            switch self.status {
            case .failure(let error):
                passStatusModel.passStatus = .notSubscribed
                print("Failed to check subscription status: \(error)")
            case .success(let status):
                passStatusModel.passStatus = status
            case .loading: break
            @unknown default: break
            }
        }
        .task {
            viewModelSubscriptions.observeTransactionUpdates()
            viewModelSubscriptions.checkForUnfinishedTransactions()
        }
    }

}

#Preview {
    HomeFactory().create()
}

extension HomeView {
    @ViewBuilder
    var planView: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Image(systemName: "crown")
                VStack(alignment: .leading) {
                    Text(passStatusModel.passStatus == .notSubscribed ?
                         "subTitle":
                            "Unique Subscription Plan: \(passStatusModel.passStatus.description)")
                        .font(.system(size: 17))
                    Text(passStatusModel.passStatus == .notSubscribed ?
                         "subsDescription":
                            "subDescriptionBought")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                }
            }
            if passStatusModel.passStatus != .notSubscribed {
                Button("Handle Subscription \(Image(systemName: "chevron.forward"))") {
                    self.presentingSubscriptionSheet = true
                }
                .foregroundStyle(Color.blue)
                .accessibilityIdentifier("btnSubscriptionActiveHomeView")
            }
        }
    }
}
