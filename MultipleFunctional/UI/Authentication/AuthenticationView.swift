//
//  AuthenticationView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import SwiftUI
import AuthenticationServices

enum AuthenticationSheetView: String, Identifiable {
    case register
    case login

    var id: String {
        return rawValue
    }
}

struct AuthenticationView: View {
    @ObservedObject private var viewModel: LoginViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var remoteConfiguration: RemoteConfiguration
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
                VStack {
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
                                    Label("emailLogin", systemImage: "envelope.fill")
                                }
                                .frame(width: 250, height: 60)
                                .cornerRadius(45)
                                .accessibilityIdentifier("btnLoginMailAuthenticationView")
                                .tint(.auth)

                                SignInWithAppleButton(.continue,
                                                      onRequest: { (request) in
                                    request.requestedScopes = [.email, .fullName]

                                },
                                                      onCompletion: { result in
                                    viewModel.handleSignInAppleResult(result)
                                })
                                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                                .frame(width: 180, height: 50)
                                .cornerRadius(45)
                                .padding(.top, 20)
                                .accessibilityIdentifier("btnLoginAppleAuthenticationView")

                                if remoteConfiguration.showButtonFaceId {
                                    Button {
                                        viewModel.authenticateBiometric()
                                    } label: {
                                        Label("faceIdLogin", systemImage: "faceid")
                                    }
                                    .frame(width: 250, height: 60)
                                    .cornerRadius(45)
                                    .accessibilityIdentifier("btnFaceIdAuthenticationView")
                                    .tint(.auth)
                                    .padding(.top, 20)
                                }

                                if viewModel.showErrorMessage != nil {
                                    Text(viewModel.showErrorMessage!)
                                        .bold()
                                        .font(.body)
                                        .foregroundColor(.red)
                                        .padding(.top, 20)
                                        .accessibilityIdentifier("authenticationViewErrorMessage")
                                }

                            }
                            .controlSize(.extraLarge)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .padding(.top, 60)

                            Spacer()

                            HStack {
                                Button {
                                    authenticationSheetView = .register
                                } label: {
                                    Text("notaccount")
                                    Text("register")
                                        .underline()
                                }
                                .accessibilityIdentifier("btnRegisterAuthenticationView")
                                .tint(.auth)
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
        .task {
            remoteConfiguration.fetch()
        }
    }

}

#Preview {
    AuthenticationFactory.create()
}
