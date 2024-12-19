//
//  AuthViewModel.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import Foundation
import Appwrite
import Observation
import Logging
import Combine

enum AuthError: Error {
    case existingUsername
    
    var message: String {
        switch self {
        case .existingUsername: "Ya existe una cuenta con el mismo nombre de usuario."
        }
    }
}

enum AuthState {
    case unauthenticated
    case authenticating
    case authenticated(User)
}

enum AuthFlow {
    case signIn
    case signUp
    case signOut
}

@Observable
class AuthViewModel {
    var state: AuthState = .authenticating
    var authFlow: AuthFlow = .signIn
    var errorMessage: String? = nil
    var user: User?
    
    
//    var username: String = ""
    var username: String = "" {
        didSet {
            Task {
                await debounceUsernameCheck()
            }
        }
    }
    var isUsernameAvailable: Bool?
    var isChecking: Bool = false
    private var debounceTask: Task<Void, Never>?
    private let debounceInterval: TimeInterval = 0.5
    
    
    var email: String = ""
    var password: String = ""
    
    private var logger = Logger(label: "com.anceldev.MyInventory")
    
    init() {
        Task {
            await checkForExistingSession()
        }
    }
    
    @MainActor
        private func debounceUsernameCheck() async {
            print("testing username")
            debounceTask?.cancel()
            
            guard !username.isEmpty else {
                isUsernameAvailable = nil
                isChecking = false
                return
            }
            
            debounceTask = Task {
                isChecking = true
                
                do {
                    try await Task.sleep(nanoseconds: UInt64(debounceInterval * 1_000_000_000))
                    
                    if Task.isCancelled { return }
                    
//                    let isAvailable = await checkUsernameAvailability(username)
                    let isAvailable = try await isUsernameAvailable()
                    
                    if Task.isCancelled { return }
                    
                    await MainActor.run {
                        isUsernameAvailable = isAvailable
                    }
                } catch {
                    print("Debounce task cancelled")
                }
                
                await MainActor.run {
                    isChecking = false
                }
            }
        }
    
    
    
    
    
    func signIn() async throws {
        do {
            self.state = .authenticating
            
            if isValidEmail(self.email) && isValidPassword(self.password) {
                _ = try await AWClient.shared.account.createEmailPasswordSession(
                    email: self.email,
                    password: self.password
                )
                let account = try await AWClient.shared.account.get()
                let user: User = try await AWClient.getModel(collection: .users, id: account.id)
                self.user = user
                self.state = .authenticated(user)
                self.authFlow = .signIn
                return
            }
            self.state = .unauthenticated
            self.errorMessage = "Invalid email or password"
            
        } catch {
            self.state = .unauthenticated
            self.errorMessage = error.localizedDescription
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func signUp() async throws {
        do {
            if isValidEmail(self.email) && isValidPassword(self.password) && !self.username.isEmpty {
                let user = try await AWClient.shared.account.create(
                    userId: ID.unique(),
                    email: self.email,
                    password: self.password,
                    name: self.username
                )
                _ = try await AWClient.shared.account.createEmailPasswordSession(
                    email: self.email,
                    password: self.password
                )
                
                let userModel = User(
                    id: user.id,
                    name: user.name,
                    username: self.username,
                    email: user.email
                )
                try await AWClient.createDocument(
                    collection: .users,
                    model: userModel
                )
                
                self.state = .authenticated(userModel)
                self.authFlow = .signIn
                return
            }
            self.state = .unauthenticated
            self.errorMessage = "Invalid email or password"
        } catch {
            self.state = .unauthenticated
            if let awError = error as? AppwriteError {
                if awError.code == 409 {
                    self.errorMessage = "Ya existe una cuenta con el mismo nombre de usuario o correo electrónico."
                    logger.error("\(error.localizedDescription)")
                    return
                }
            }
            self.errorMessage = error.localizedDescription
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func signOut() async {
        do {
            _ = try await AWClient.shared.account.deleteSession(sessionId: "current")
            resetValues()
        } catch {
            self.errorMessage = error.localizedDescription
            logger.error("\(error.localizedDescription)")
        }
    }
    
    func isUsernameAvailable() async throws -> Bool {
        do {
            let queries = [Query.equal("username", value: self.username.lowercased())]
            let existingUser: [User] = try await AWClient.getDocumentsWithQuery(collection: .users, queries: queries)
            if existingUser.count > 0 {
                throw AuthError.existingUsername
            }
            self.errorMessage = nil
            return true
        } catch {
            logger.error("\(error.localizedDescription)")
            if let authError = error as? AuthError {
                self.errorMessage = authError.message
                return false
            }
            self.errorMessage = error.localizedDescription
            print(self.errorMessage ?? "Error founded")
            return false
        }
    }
    
    private func checkForExistingSession() async {
        do {
            self.state = .authenticating
            let account = try await AWClient.shared.account.get()
            let user: User = try await AWClient.getModel(collection: .users, id: account.id)
            self.user = user
            self.state = .authenticated(user)
        } catch {
            self.state = .unauthenticated
            if let appwriteError = error as? AppwriteError {
                if appwriteError.code != 401 {
                    self.errorMessage = error.localizedDescription
                }
            }
            return
        }
    }
    
    private func resetValues() {
        self.email = ""
        self.password = ""
        self.username = ""
        self.user = nil
        self.state = .unauthenticated
        self.errorMessage = nil
        self.authFlow = .signIn
    }
}

extension AuthViewModel {
    
    private func validateFields(for email: String, with password: String) -> Bool {
        if isValidEmail(email) && isValidEmail(password) {
            return true
        }
        return false
    }
    
    /// Validates a email with a regular expression
    /// - Parameter email: email
    /// - Returns: true if regular expression is true
    private func isValidEmail(_ email: String) -> Bool {
        let emailReges = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        return (email.range(of: emailReges, options: .regularExpression) != nil)
    }
    
    /// Validates a password with a regular expression
    /// - Parameter password: password
    /// - Returns: true if regular expression is true
    private func isValidPassword(_ password: String) -> Bool {
        let passwordReges = "[A-Z0-9a-z]{8,16}"
        return (password.range(of: passwordReges, options: .regularExpression) != nil)
    }
}

