//
//  ContentView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 27/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            CustomTextField("Nombre", text: $text, fieldType: .name)
            CustomTextField("Email", text: $text, fieldType: .email)
            CustomTextField("Search", text: $text, fieldType: .search)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
