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
    var state: AuthState = .unauthenticated
    var authFlow: AuthFlow = .signIn
    var errorMessage: String? = nil
    var user: User?
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    private var logger = Logger(label: "com.anceldev.MyInventory")
    
    init() {
        Task {
            await checkForExistingSession()
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
    
    private func checkForExistingSession() async {
        do {
            self.state = .authenticating
            let account = try await AWClient.shared.account.get()
            let user: User = try await AWClient.getModel(collection: .users, id: account.id)
            self.user = user
            self.state = .authenticated(user)
        } catch {
            logger.error("\(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.state = .unauthenticated
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

