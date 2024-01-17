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
            VStack {
                Text("Bienvenido \(viewModel.user?.email ?? "No user")")
                    .padding(.top, 32)
                    .accessibilityIdentifier("titleHomeView")
                Spacer()

                Button("🛒 Compras") {
                    // viewModel.logIn(email: textFieldEmail, password: textFieldPassword)
                }

                Spacer()

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
