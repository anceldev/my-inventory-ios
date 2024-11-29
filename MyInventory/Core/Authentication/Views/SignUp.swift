//
//  SignUp.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct SignUp: View {
    @Environment(AuthViewModel.self) var authVM
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack {
            Text("Sign Up")
                .font(.title)
            Form {
                TextField("Username", text: $authVM.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                TextField("Email", text: $authVM.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Passowrd", text: $authVM.password)
                Button {
                    authVM.authFlow = .signIn
                    print("Got to sign in...")
                } label: {
                    Text("Already have account? Sign in")
                }
            }
            Button {
                signUp()
            } label: {
                Text("Sign In")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func signUp() {
        Task {
            do {
                try await authVM.signUp()
            } catch {
                return
            }
        }
    }
}

#Preview {
    SignUp()
        .environment(AuthViewModel())
}
