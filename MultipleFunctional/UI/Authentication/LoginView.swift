//
//  LoginView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            DismissView()
                .padding(.top, 8)
            Group {
                Text("👋 Bienvenido de nuevo a")
                Text("MultipleFunctional")
                    .bold()
                    .underline()
            }
            .accessibilityIdentifier("groupTitleLoginView")
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .tint(.primary)
            Group {
                Text("Loguéate de nuevo para poder acceder a MultipleFunctional.")
                    .tint(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                    .accessibilityIdentifier("textDescriptionLoginView")

                TextField("Añade tu correo electrónico", text: $textFieldEmail)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("fieldEmailLoginView")

                TextField("Añade tu contraseña", text: $textFieldPassword)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("fieldPassLoginView")

                Button("Login") {
                    viewModel.logIn(email: textFieldEmail, password: textFieldPassword)
                }
                .accessibilityIdentifier("btnLoginEmailLoginView")
                .padding(.top, 18)
                .buttonStyle(.bordered)
                .tint(.blue)

                if let messageError = viewModel.showErrorMessageLogin {
                    Text(messageError)
                        .bold()
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                        .accessibilityIdentifier("loginViewErrorMessage")
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 64)
            Spacer()
        }

    }
}

#Preview {
    LoginFactory().create()
}
