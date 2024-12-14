//
//  SignUp.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct SignUp: View {
    
    enum FormFields {
        case username
        case email
        case password
    }
    
    @Environment(AuthViewModel.self) var authVM
    @FocusState private var focused: FormFields?
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack(alignment: .leading) {
            Text("Sign Up")
                .font(.system(size: 50, weight: .bold))
                .padding(.bottom, 16)
                .foregroundStyle(.neutral700)
            VStack(spacing: 16) {
                TextField("Usuario", text: $authVM.username)
                    .customTextField("Username", icon: "person")
                    .submitLabel(.next)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focused, equals: .username)
                    .onSubmit {
                        focused = .email
                    }
                
                TextField("Correo", text: $authVM.email)
                    .customTextField("Email", icon: "at")
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .focused($focused, equals: .email)
                    .onSubmit {
                        focused = .password
                    }
                
                SecureField("Contraseña", text: $authVM.password)
                    .customTextField("Contraseña", icon: "key")
                    .submitLabel(.go)
                    .focused($focused, equals: .password)
                    .onSubmit {
                        signUp()
                    }
                
                HStack {
                    Text("Already have account?")
                        .foregroundStyle(.neutral600)
                    Button {
                        authVM.authFlow = .signIn
                        print("Got to sign in...")
                    } label: {
                        Text("Sign in.")
                            .foregroundStyle(.neutral700)
                            .bold()
                    }
                }
                .font(.system(size: 14))
            }
            Button {
                signUp()
            } label: {
                Text("Sign Un")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(.neutral100)
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
