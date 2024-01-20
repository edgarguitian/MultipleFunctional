/**
 Handles the login functionality and user authentication.
 
 - Author: Edgar Guitian Rey
 */

import Foundation
import AuthenticationServices
import LocalAuthentication
import FirebaseAuth

final class LoginViewModel: ObservableObject {
    private let getUserUseCase: GetUserUseCaseType
    private let loginEmailUseCase: LoginEmailUseCaseType
    private let loginAppleUseCase: LoginAppleUseCaseType
    private let logoutUseCase: LogoutUseCaseType
    private let registerUseCase: RegisterUseCaseType
    private let errorMapper: MultipleFunctionalPresentableErrorMapper

    @Published var showErrorMessage: String?
    @Published var showErrorMessageLogin: String?
    @Published var showErrorMessageRegister: String?
    @Published var showLoadingSpinner: Bool = true
    @Published var user: User?

    init(getUserUseCase: GetUserUseCaseType,
         loginUseCase: LoginEmailUseCaseType,
         loginAppleUseCase: LoginAppleUseCaseType,
         logoutUseCase: LogoutUseCaseType,
         registerUseCase: RegisterUseCaseType,
         errorMapper: MultipleFunctionalPresentableErrorMapper) {
        self.getUserUseCase = getUserUseCase
        self.loginEmailUseCase = loginUseCase
        self.loginAppleUseCase = loginAppleUseCase
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
    func logInEmail(email: String, password: String) {
        showLoadingSpinner = true
        Task {
            let result = await loginEmailUseCase.execute(email: email,
                                                    password: password)
            handleResult(result, fromLogin: true)
        }
    }

    /**
     Logs in a user with the provided apple
     */
    func logInApple(credential: ASAuthorizationAppleIDCredential) {
        showLoadingSpinner = true
        Task {
            let token = credential.identityToken ?? Data()

            let appleCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                           idToken: String(data: token, encoding: .utf8)!,
                                                           rawNonce: nil)

            let result = await loginAppleUseCase.execute(credential: appleCredential)
            handleResult(result, fromLogin: true)
        }
    }

    /**
     Logs in a user with the provided Biometric
     */
    func authenticateBiometric() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Por favor autentícate para poder continuar") { success, error in

                self.readBiometric(success: success, error: error)
            }
        } else {
            readBiometric(success: false, error: nil)
        }
    }

    /**
     Handle the result of Sign In with Apple
     */
    func handleSignInAppleResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let credential as ASAuthorizationAppleIDCredential:
                logInApple(credential: credential)
            default:
                showErrorMessage = "No se pudo continuar con la cuenta de Apple"
            }
        case .failure(let error):
            showErrorMessage = error.localizedDescription
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

    func readBiometric(success: Bool, error: Error?) {
        if success {
            Task {
                let result = await registerUseCase.execute(email: "biometricUser@gmail.com",
                                                        password: "passBiometric")
                handleResult(result, fromLogin: false)
            }
        } else {
            if let error = error {
                showErrorMessage = error.localizedDescription
            } else {
                showErrorMessage = "No biometrics supported"
            }
        }
    }
}
