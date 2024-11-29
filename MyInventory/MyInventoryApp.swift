//
//  MyInventoryApp.swift
//  MyInventory
//
//  Created by Ancel Dev account on 27/11/24.
//

import SwiftUI

@main
struct MyInventoryApp: App {
    
    @State var authVM = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView()
                .environment(authVM)
        }
    }
}
