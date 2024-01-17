/**
 Handles the login functionality and user authentication.
 
 - Author: Edgar Guitian Rey
 */

import Foundation

final class LoginViewModel: ObservableObject {
    private let getUserUseCase: GetUserUseCaseType
    private let loginUseCase: LoginUseCaseType
    private let logoutUseCase: LogoutUseCaseType
    private let registerUseCase: RegisterUseCaseType
    private let errorMapper: MultipleFunctionalPresentableErrorMapper

    @Published var showErrorMessage: String?
    @Published var showErrorMessageLogin: String?
    @Published var showErrorMessageRegister: String?
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

    /**
     Retrieves the current user's information.
     */
    func getCurrentUser() {
        let uiTestErrorHandling = ProcessInfo.processInfo.arguments.contains("UITestErrorHandling")
        if uiTestErrorHandling {
            showErrorMessage = "Error al cargar la vista en UITest"
        } else {
            Task {
                let result = await getUserUseCase.execute()
                handleResultGetCurrentUser(result)
            }
        }
    }

    /**
     Logs in a user with the provided email and password.
     */
    func logIn(email: String, password: String) {
        showLoadingSpinner = true
        Task {
            let result = await loginUseCase.execute(email: email,
                                                    password: password)
            handleResult(result, fromLogin: true)
        }
    }

    /**
     Logs out the current user.
     */
    func logOut() {
        showLoadingSpinner = true
        Task {
            let result = await logoutUseCase.execute()
            handleResultLogOut(result)
        }
    }

    /**
     Creates a new user with the provided email and password.
     */
    func createNewUser(email: String, password: String) {
        showLoadingSpinner = true
        Task {
            let result = await registerUseCase.execute(email: email,
                                                    password: password)
            handleResult(result, fromLogin: false)
        }
    }

    func handleResult(_ result: Result<User, MultipleFunctionalDomainError>, fromLogin: Bool) {
        guard case .success(let loginResult) = result else {
            handleError(error: result.failureValue as? MultipleFunctionalDomainError, fromLogin: fromLogin)
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.user = loginResult
        }
    }

    func handleResultGetCurrentUser(_ result: User?) {

        Task { @MainActor in
            showLoadingSpinner = false
            self.user = result
        }
    }

    func handleResultLogOut(_ result: Result<Bool, MultipleFunctionalDomainError>) {
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

    private func handleError(error: MultipleFunctionalDomainError?, fromLogin: Bool) {
        Task { @MainActor in
            showLoadingSpinner = false
            if fromLogin {
                showErrorMessageLogin = errorMapper.map(error: error)
            } else {
                showErrorMessageRegister = errorMapper.map(error: error)
            }
        }
    }
}
