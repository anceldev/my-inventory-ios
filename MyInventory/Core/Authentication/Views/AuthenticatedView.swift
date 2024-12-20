//
//  AuthenticatedView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct AuthenticatedView: View {
    @Environment(AuthViewModel.self) var authVM
    var body: some View {
        VStack {
            switch authVM.state {
            case .authenticated(let userId):
                RootView(for: userId)
            case .authenticating:
                ProgressView()
            case .unauthenticated:
                AuthenticationView()
            }
        }
    }
}

#Preview {
    AuthenticatedView()
        .environment(AuthViewModel())
}
