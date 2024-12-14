//
//  SegmentedControl.swift
//  MyInventory
//
//  Created by Ancel Dev account on 14/12/24.
//

import SwiftUI

struct SegmentedControl: View {
    @Binding var state: ItemStatus
    let addIcon: Bool
    
    @Namespace private var segmentedControl
    
    var colorSegment: Color {
        switch state {
        case .new: .greenLight
        case .used: .tealLight
        case .damaged: .yellowLight
        }
    }
    
    var body: some View {
        VStack(alignment: .leading , spacing: 6) {
            Text("Estado")
                .font(.system(size: 14))
            HStack {
                ForEach(ItemStatus.allCases) { state in
                    Button {
                        withAnimation(.bouncy) {
                            self.state = state
                        }
                    } label: {
                        HStack(spacing: 6) {
                            if addIcon {
                                Image(systemName: state.icon)
                                    .resizable()
                                    .frame(width: 17, height: 17)
                            }
                            Text(state.rawValue)
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .lineSpacing(20)
                        }
                        .foregroundStyle(self.state == state ? .neutral900 : .neutral400)
                    }
                    .padding(.horizontal, 19)
                    .frame(maxWidth: .infinity)
                    .frame(height: 28)
                    .matchedGeometryEffect(
                        id: state,
                        in: segmentedControl
                    )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 6)
//                    .fill(.purpleBase)
                    .fill(colorSegment)
                    .matchedGeometryEffect(
                        id: state,
                        in: segmentedControl,
                        isSource: false
                    )
            )
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}
