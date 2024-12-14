//
//  SignIn.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct SignIn: View {
    
    enum FormFields {
        case email
        case password
    }
    
    @Environment(AuthViewModel.self) var authVM
    @FocusState private var focused: FormFields?
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack(alignment: .leading) {
            Text("Sign In")
                .font(.system(size: 50, weight: .bold))
                .padding(.bottom, 16)
                .foregroundStyle(.neutral700)
            VStack(spacing: 16) {
                TextField("Email", text: $authVM.email)
                    .customTextField("Correo", icon: "at")
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                    .focused($focused, equals: .email)
                    .onSubmit {
                        focused = .password
                    }
                SecureField("Passowrd", text: $authVM.password)
                    .customTextField("Password", icon: "key")
                    .submitLabel(.go)
                    .focused($focused, equals: .password)
                    .onSubmit {
                        signIn()
                    }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundStyle(.neutral600)
                    Button {
                        authVM.authFlow = .signUp
                        print("Go to sign up...")
                    } label: {
                        Text("Sign Up.")
                            .foregroundStyle(.neutral700)
                            .bold()
                    }
                }
                .font(.system(size: 14))
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
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.neutral200)
        .onChange(of: authVM.authFlow) {
            print(authVM.authFlow)
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
    NavigationStack {
        SignIn()
            .environment(AuthViewModel())
    }
}


