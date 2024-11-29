//
//  AuthenticationView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    
    @Environment(AuthViewModel.self) var authVM
    
    var body: some View {
        VStack {
            switch authVM.authFlow {
            case .signIn:
                SignIn()
            case .signUp:
                SignUp()
            case .signOut:
                Text("You need to sign in to start")
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environment(AuthViewModel())
}
