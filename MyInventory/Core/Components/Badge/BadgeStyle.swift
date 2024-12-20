//
//  BadgeStyle.swift
//  AlignUISwiftUIComponents
//
//  Created by Ancel Dev account on 2/12/24.
//

import SwiftUI

protocol BadgeStyle {
    associatedtype Body: View
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = BadgeStyleConfiguration
}

struct BadgeStyleConfiguration {
    let label: AnyView
}

struct BadgeModifier<Style: BadgeStyle>: ViewModifier {
    let style: Style
    
    func body(content: Content) -> some View {
        style.makeBody(configuration: .init(label: AnyView(content)))
    }
}

struct AnyBadgeStyle: BadgeStyle {
    private let _makeBody: (Configuration) -> AnyView
    
    init<S: BadgeStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

extension View {
    func badgeStyle<Style: BadgeStyle>(_ style: Style) -> some View {
        modifier(BadgeModifier(style: style))
    }
}

struct NormalBadgeStyle: BadgeStyle {
    let color: BadgeColor
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
                .font(.system(size: 11))
                .lineSpacing(12)
                .foregroundStyle(color.text)
                .fontWeight(.medium)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(color.bg)
        .clipShape(.capsule)
        .frame(minWidth: 56)
        .frame(height: 16)
    }
}

struct DottedBadgeStyle: BadgeStyle {
    let color: BadgeColor
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 4, height: 4)
                configuration.label
                    .font(.system(size: 11))
                    .lineSpacing(12)
                    .fontWeight(.medium)
            }
            .foregroundStyle(color.text)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(color.bg)
        .clipShape(.capsule)
        .frame(minWidth: 56)
        .frame(height: 16)
    }
}

struct IconnedBadgeStyle: BadgeStyle {
    let color: BadgeColor
    let icon: String
    let isIconLeading: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        
        VStack {
            if isIconLeading {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .resizable()
                        .frame(width: 8, height: 8)
                        .fontWeight(.bold)
                    configuration.label
                        .font(.system(size: 11))
                        .lineSpacing(12)
                        .fontWeight(.medium)
                }
                .foregroundStyle(color.text)
            } else {
                HStack(spacing: 4) {
                    configuration.label
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
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(color.bg)
        .clipShape(.capsule)
        .frame(minWidth: 56)
        .frame(height: 16)
    }
}
struct OutlinedBadgeStyle: BadgeStyle {
    let color: BadgeColor
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
                .font(.system(size: 11))
                .lineSpacing(12)
                .foregroundStyle(color.text)
                .fontWeight(.medium)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(.clear)
        .clipShape(
            Capsule()
        )
        .overlay {
            Capsule()
                .stroke(color.bg , lineWidth: 1)
        }
    }
}

extension BadgeStyle where Self == AnyBadgeStyle {
    static func normal(color: BadgeColor) -> AnyBadgeStyle {
        AnyBadgeStyle(NormalBadgeStyle(color: color))
    }

    static func outlined(color: BadgeColor) -> AnyBadgeStyle {
        AnyBadgeStyle(OutlinedBadgeStyle(color: color))
    }
    static func dotted(color: BadgeColor) -> AnyBadgeStyle {
        AnyBadgeStyle(DottedBadgeStyle(color: color))
    }
    static func icon(color: BadgeColor, icon: String, isIconLeading: Bool) -> AnyBadgeStyle {
        AnyBadgeStyle(IconnedBadgeStyle(color: color, icon: icon, isIconLeading: isIconLeading))
    }
}



struct Badge: View {
    let name: String
    @Binding var isOn: Bool
    
    init(_ name: String, isOn: Binding<Bool>) {
        self.name = name
        self._isOn = isOn
    }
    
    var body: some View {
        Text(name)
            .animation(.easeInOut(duration: 0.3), value: isOn)
                        .onTapGesture {
                            isOn.toggle()
                        }
    }
}
#Preview {
    @Previewable @State var isOn = true
    VStack {
        Text("BADGE")

        Badge("BADGE", isOn: $isOn)
            .badgeStyle(isOn ? .normal(color: .pink) : .outlined(color: .outlined))
        Badge("BADGE", isOn: $isOn)
            .badgeStyle(isOn ? .dotted(color: .green) : .outlined(color: .outlined))
    }
}
