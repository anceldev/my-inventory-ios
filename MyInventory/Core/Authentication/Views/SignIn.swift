//
//  SignIn.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct SignIn: View {
    
    @Environment(AuthViewModel.self) var authVM
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack {
            Text("Sign In")
                .font(.title)
            Form {
                TextField("Email", text: $authVM.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Passowrd", text: $authVM.password)
                Button {
                    authVM.authFlow = .signUp
                    print("Go to sign up...")
                } label: {
                    Text("Don't have an account? Sign Up")
                }
                if let errorMessage = authVM.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            Button {
                signIn()
            } label: {
                Text("Sign In")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func signIn() {
        Task {
            do {
                try await authVM.signIn()
            } catch {
                return
            }
        }
    }
}

#Preview {
    SignIn()
        .environment(AuthViewModel())
}


