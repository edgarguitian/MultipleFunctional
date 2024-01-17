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
    @ObservedObject private var viewModelProducts: ProductSubscriptionViewModel

    private let createShopView: CreateShopView
    @State private var showScriptionView: Bool = false
    @State private var presentingSubscriptionSheet = false
    @State private var status: EntitlementTaskState<PassStatus> = .loading
    @Environment(\.passIDs) private var passIDs
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel

    init(viewModelLogin: LoginViewModel,
         viewModelProducts: ProductSubscriptionViewModel,
         createShopView: CreateShopView) {
        self.viewModelLogin = viewModelLogin
        self.viewModelProducts = viewModelProducts
        self.createShopView = createShopView
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Bienvenido \(viewModelLogin.user?.email ?? "No user")")
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
                                Text("View Options")
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
                }
                .sheet(isPresented: $showScriptionView, content: {
                    createShopView.create()
                })

                Spacer()

            }

            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Home")
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
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            self.status = taskStatus.map { statuses in
                viewModelProducts.status(
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
            viewModelProducts.observeTransactionUpdates()
            viewModelProducts.checkForUnfinishedTransactions()
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
            Text(passStatusModel.passStatus == .notSubscribed ?
                 "Unique Subscription":
                    "Unique Subscription Plan: \(passStatusModel.passStatus.description)")
                .font(.system(size: 17))
            Text(passStatusModel.passStatus == .notSubscribed ?
                 "Subscription to unlock all the content.":
                    "Enjoy all the content")
                .font(.system(size: 15))
                .foregroundStyle(.gray)
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
