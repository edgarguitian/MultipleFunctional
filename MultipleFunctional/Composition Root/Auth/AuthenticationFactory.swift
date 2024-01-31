//
//  AuthenticationFactory.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 15/1/24.
//

import Foundation

class AuthenticationFactory {
    static var sharedAuthRepository: AuthRepositoryType = createAuthRepository()
    static var sharedLoginViewModel: LoginViewModel = createViewModel()

    static func create() -> AuthenticationView {
        return AuthenticationView(viewModel: sharedLoginViewModel,
                                  createLoginView: LoginFactory(),
                                  createRegisterView: RegisterFactory(),
                                  createHomeView: HomeFactory())
    }

    private static func createViewModel() -> LoginViewModel {
        return LoginViewModel(getUserUseCase: createGetUserUseCase(),
                              loginUseCase: createLoginEmailUseCase(),
                              loginAppleUseCase: createLoginAppleUseCase(),
                              logoutUseCase: createLogoutUseCase(),
                              registerUseCase: createRegisterUseCase(),
                              errorMapper: MultipleFunctionalPresentableErrorMapper())
    }

    private static func createGetUserUseCase() -> GetUserUseCaseType {
        return GetUserUseCase(repository: sharedAuthRepository)
    }

    private static func createLoginEmailUseCase() -> LoginEmailUseCaseType {
        return LoginEmailUseCase(repository: sharedAuthRepository)
    }

    private static func createLoginAppleUseCase() -> LoginAppleUseCaseType {
        return LoginAppleUseCase(repository: sharedAuthRepository)
    }

    private static func createLogoutUseCase() -> LogoutUseCaseType {
        return LogoutUseCase(repository: sharedAuthRepository)
    }

    private static func createRegisterUseCase() -> RegisterUseCaseType {
        return RegisterUseCase(repository: sharedAuthRepository)
    }

    private static func createAuthRepository() -> AuthRepositoryType {
        return AuthRepository(authenticationFirebaseDatasource: createAuthFirebaseDataSource(),
                              errorMapper: MultipleFunctionalDomainErrorMapper())
    }

    private static func createAuthFirebaseDataSource() -> AuthenticationFirebaseDataSourceType {
        return AuthenticationFirebaseDataSource()
    }
}
