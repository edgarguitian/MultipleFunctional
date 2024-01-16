//
//  HomeView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    Text("Bienvenido \(viewModel.user?.email ?? "No user")")
                        .padding(.top, 32)
                        .accessibilityIdentifier("titleHomeView")
                    Spacer()

                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            }

            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Home")
            .toolbar {
                Button("Logout") {
                    viewModel.logOut()
                }
                .accessibilityIdentifier("btnLogout")
            }
        }
    }
}

#Preview {
    HomeFactory().create()
}
