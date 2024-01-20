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
                Text("welcometo")
                Text("MultipleFunctional")
                    .bold()
                    .underline()
            }
            .accessibilityIdentifier("groupTitleRegisterView")
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .tint(.primary)

            Group {
                Text("registerTitle")
                    .tint(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                    .accessibilityIdentifier("textDescriptionRegisterView")

                TextField("emailPlaceholder", text: $textFieldEmail)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("fieldEmailRegisterView")

                SecureField("passwordPlaceholder", text: $textFieldPassword)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("fieldPassRegisterView")

                Button("accept") {
                    viewModel.createNewUser(email: textFieldEmail,
                                            password: "\(textFieldPassword)")
                }
                .accessibilityIdentifier("btnRegisterEmailRegisterView")
                .padding(.top, 18)
                .buttonStyle(.bordered)
                .tint(.blue)

                if let messageError = viewModel.showErrorMessageRegister {
                    Text(messageError)
                        .bold()
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                        .accessibilityIdentifier("registerViewErrorMessage")
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 64)
            Spacer()
        }
        .onAppear {
            viewModel.showErrorMessageRegister = nil
        }
    }
}

#Preview {
    RegisterFactory().create()
}
