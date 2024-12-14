//
//  CustomToggle.swift
//  MyInventory
//
//  Created by Ancel Dev account on 13/12/24.
//

import SwiftUI

struct CustomToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(isOn ? .purpleBase : .neutral300)
            Circle()
                .fill(.white)
                .frame(width: 12)
                .position(x: isOn ? 20 : 8, y: 8)
                .overlay {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.gray.opacity(0.3), .white], startPoint: .bottom, endPoint: .top)
                        )
                        .frame(width: 11)
                        .position(x: isOn ? 20 : 8, y: 7.5)
                }
            Circle()
                .fill(isOn ? .purpleBase : .neutral300)
                .frame(width: 4)
                .position(x: isOn ? 20 : 8, y: 8)
        }
        .padding(2)
        .frame(width: 32, height: 20)
        .onTapGesture {
            withAnimation(.linear(duration: 0.25)) {
                isOn.toggle()
            }
        }
    }
}
