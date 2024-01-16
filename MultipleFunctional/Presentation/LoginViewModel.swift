//
//  LoginViewModel.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

final class LoginViewModel: ObservableObject {
    private let getUserUseCase: GetUserUseCaseType
    private let loginUseCase: LoginUseCaseType
    private let logoutUseCase: LogoutUseCaseType
    private let registerUseCase: RegisterUseCaseType
    private let errorMapper: MultipleFunctionalPresentableErrorMapper
    @Published var showErrorMessage: String?
    @Published var showLoadingSpinner: Bool = true
    @Published var user: User?

    init(getUserUseCase: GetUserUseCaseType,
         loginUseCase: LoginUseCaseType,
         logoutUseCase: LogoutUseCaseType,
         registerUseCase: RegisterUseCaseType,
         errorMapper: MultipleFunctionalPresentableErrorMapper) {
        self.getUserUseCase = getUserUseCase
        self.loginUseCase = loginUseCase
        self.logoutUseCase = logoutUseCase
        self.registerUseCase = registerUseCase
        self.errorMapper = errorMapper
    }

    func getCurrentUser() {
        let uiTestErrorHandling = ProcessInfo.processInfo.arguments.contains("UITestErrorHandling")
        if uiTestErrorHandling {
            showErrorMessage = "Error al cargar la vista en UITest"
        } else {
            Task {
                let result = await getUserUseCase.execute()
                handleResult(result)
            }
        }
    }

    func logIn(email: String, password: String) {
        showLoadingSpinner = true
        Task {
            let result = await loginUseCase.execute(email: email,
                                                    password: password)
            handleResult(result)
        }
    }

    func logOut() {
        showLoadingSpinner = true
        Task {
            let result = await logoutUseCase.execute()
            handleResult(result)
        }
    }

    func createNewUser(email: String, password: String) {
        showLoadingSpinner = true
        Task {
            let result = await registerUseCase.execute(email: email,
                                                    password: password)
            handleResult(result)
        }
    }

    func handleResult(_ result: Result<User, MultipleFunctionalDomainError>) {
        guard case .success(let loginResult) = result else {
            handleError(error: result.failureValue as? MultipleFunctionalDomainError)
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.user = loginResult
        }
    }

    func handleResult(_ result: User?) {

        Task { @MainActor in
            showLoadingSpinner = false
            self.user = result
        }
    }

    func handleResult(_ result: Result<Bool, MultipleFunctionalDomainError>) {
        switch result {
            case .success:
                Task { @MainActor in
                    showLoadingSpinner = false
                    self.user = nil
                }
            case .failure:
                handleError(error: result.failureValue as? MultipleFunctionalDomainError)
            }

    }

    private func handleError(error: MultipleFunctionalDomainError?) {
        Task { @MainActor in
            showLoadingSpinner = false
            showErrorMessage = errorMapper.map(error: error)
        }
    }
}
