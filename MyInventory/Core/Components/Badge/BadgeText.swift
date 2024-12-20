 //
//  Badge.swift
//  AlignUISwiftUIComponents
//
//  Created by Ancel Dev account on 2/12/24.
//

import SwiftUI
enum BadgeType {
    case filled
    case outlined
}
enum BadgeVariant {
    case normal
    case dotted
    case icon(leading: Bool, String)
}

enum BadgeColor: String {
    case blue
    case orange
    case red
    case yellow
    case green
    case purple
    case pink
    case teal
    case gray
    case outlined
    
    var bg: Color {
        if self == .outlined {
            Color("neutral200")
        } else {
            Color("\(self.rawValue)Light")
        }
    }
    
    var text: Color {
        if self == .outlined {
            Color("neutral300")
        } else {
            Color("\(self.rawValue)Darker")
        }
    }
}

struct BadgeText: View {
    let variant: BadgeVariant
    let text: String
    let color: BadgeColor
    @Binding var isOn: Bool
    
    init(variant: BadgeVariant, text: String, color: BadgeColor, isOn: Binding<Bool>) {
        self.variant = variant
        self.text = text
        self.color = color
        self._isOn = isOn
    }
    
    @ViewBuilder
    func content(color: BadgeColor) -> some View {
        switch self.variant {
        case .normal:
            Text(text)
                .font(.system(size: 11))
                .lineSpacing(12)
                .foregroundStyle(color.text)
                .fontWeight(.medium)
        case .dotted:
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 4, height: 4)
                Text(text)
                    .font(.system(size: 11))
                    .lineSpacing(12)
                    .fontWeight(.medium)
            }
            .foregroundStyle(color.text)
        case .icon(let leading, let icon):
            if leading {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 8, height: 8)
                        .fontWeight(.bold)
                    Text(text)
                        .font(.system(size: 11))
                        .lineSpacing(12)
                        .fontWeight(.medium)
                }
                .foregroundStyle(color.text)
            } else {
                HStack(spacing: 4) {
                    Text(text)
                        .fontWeight(.medium)
                        .font(.system(size: 11))
                        .lineSpacing(12)
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 8, height: 8)
                        .fontWeight(.bold)
                }
                .foregroundStyle(color.text)
            }
        }
    }

    var body: some View {
        VStack {
            if isOn {
                VStack {
                    content(color: color)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(color.bg)
                .clipShape(.capsule)
                .frame(minWidth: 56)
                .frame(height: 16)
            } else {
                VStack {
                    content(color: .outlined)
                }
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(.clear)
                .clipShape(
                    Capsule()
                )
                .overlay {
                    Capsule()
                        .stroke(BadgeColor.outlined.bg , lineWidth: 1)
                }
                .frame(height: 16)
            }
        }
        .onTapGesture {
            withAnimation(.easeOut) {
                isOn.toggle()
            }
        }
    }
}

#Preview(
    traits: .sizeThatFitsLayout,
    body: {
        @Previewable @State var badgeOn = false
        VStack {
            VStack {
                Text("Test badge")
                
                BadgeText(
                    variant: .normal,
                    text: "BADGE",
                    color: .green,
                    isOn: $badgeOn
                )
                BadgeText(
                    variant: .dotted,
                    text: "BADGE",
                    color: .blue,
                    isOn: $badgeOn
                )
                BadgeText(
                    variant: .icon(leading: false, "rays"),
                    text: "BADGE",
                    color: .purple,
                    isOn: $badgeOn
                )
                BadgeText(
                    variant: .icon(leading: true, "rays"),
                    text: "BADGE",
                    color: .pink,
                    isOn: $badgeOn
                )
        }
    }
})
