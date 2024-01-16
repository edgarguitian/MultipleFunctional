//
//  AuthenticationView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import SwiftUI

enum AuthenticationSheetView: String, Identifiable {
    case register
    case login

    var id: String {
        return rawValue
    }
}

struct AuthenticationView: View {
    @ObservedObject private var viewModel: LoginViewModel

    @State private var authenticationSheetView: AuthenticationSheetView?
    private let createLoginView: CreateLoginView
    private let createRegisterView: CreateRegisterView
    private let createHomeView: CreateHomeView

    init(viewModel: LoginViewModel,
         authenticationSheetView: AuthenticationSheetView? = nil,
         createLoginView: CreateLoginView,
         createRegisterView: CreateRegisterView,
         createHomeView: CreateHomeView) {
        self.viewModel = viewModel
        self.createLoginView = createLoginView
        self.createRegisterView = createRegisterView
        self.createHomeView = createHomeView
    }

    var body: some View {
        VStack {
            if viewModel.showLoadingSpinner {
                CustomLoadingView()
            } else {
                if viewModel.showErrorMessage == nil {
                    if viewModel.user != nil {
                        createHomeView.create()
                    } else {
                        VStack {
                            Text("MultipleFunctional")
                                .bold()
                                .font(.title)
                                .padding(.top, 100)
                                .accessibilityIdentifier("textTitleAuthenticationView")
                            VStack {
                                Button {
                                    authenticationSheetView = .login
                                } label: {
                                    Label("Entra con Email", systemImage: "envelope.fill")
                                }
                                .accessibilityIdentifier("btnLoginMailAuthenticationView")
                                .tint(.black)
                            }
                            .controlSize(.large)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .padding(.top, 60)
                            Spacer()
                            HStack {
                                Button {
                                    authenticationSheetView = .register
                                } label: {
                                    Text("¿No tienes cuenta?")
                                    Text("Regístrate")
                                        .underline()
                                }
                                .accessibilityIdentifier("btnRegisterAuthenticationView")
                                .tint(.black)
                            }
                        }
                        .sheet(item: $authenticationSheetView) { sheet in
                            switch sheet {
                            case .register:
                                createRegisterView.create()
                            case .login:
                                createLoginView.create()
                            }
                        }
                    }
                } else {
                    Text(viewModel.showErrorMessage!)
                        .accessibilityIdentifier("authenticationViewErrorMessage")
                }
            }
        }
        .onAppear {
            let uiTestInitialLoading = ProcessInfo.processInfo.arguments.contains("UITestInitialLoading")
            if uiTestInitialLoading {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            viewModel.getCurrentUser()
                        }
            } else {
                viewModel.getCurrentUser()
            }
        }
    }
}

#Preview {
    AuthenticationFactory.create()
}
