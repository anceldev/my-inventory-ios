//
//  Title.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct Title: View {
    let title: String
    let fontSize: CGFloat
    
    init(_ title: String, fontSize: CGFloat) {
        self.title = title
        self.fontSize = fontSize
    }
    var body: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .bold))
            .padding(.bottom, 16)
            .foregroundStyle(.neutral700)
    }
}
