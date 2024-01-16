//
//  RegisterView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import SwiftUI

struct RegisterView: View {
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
                Text("👋 Bienvenido a")
                Text("MultipleFunctional")
                    .bold()
                    .underline()
            }
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .tint(.primary)

            Group {
                Text("Regístrate para poder acceder a MultipleFunctional.")
                    .tint(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)

                TextField("Añade tu correo electrónico", text: $textFieldEmail)
                    .autocapitalization(.none)

                SecureField("Añade tu contraseña", text: $textFieldPassword)
                    .autocapitalization(.none)
                Button("Aceptar") {
                    viewModel.createNewUser(email: textFieldEmail,
                                            password: "\(textFieldPassword)")
                }
                .padding(.top, 18)
                .buttonStyle(.bordered)
                .tint(.blue)

                if let messageError = viewModel.showErrorMessage {
                    Text(messageError)
                        .bold()
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 64)
            Spacer()
        }
    }
}

#Preview {
    RegisterFactory().create()
}
