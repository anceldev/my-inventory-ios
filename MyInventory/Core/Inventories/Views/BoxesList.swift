//
//  BoxesList.swift
//  MyInventory
//
//  Created by Ancel Dev account on 11/12/24.
//

import SwiftUI

struct BoxesList: View {
    let boxes: [Box] = Box.boxesPreview
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(boxes) { box in
                BoxView(box)
            }
        }
    }
    
    @ViewBuilder
    func BoxView(_ box: Box) -> some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack {
                Text(box.name)
                    .font(.system(size: 18, weight: .medium))
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .padding(6)
                    .background(.white, in: .circle)
                    .foregroundStyle(.neutral600)
            }
            VStack {
                Text("2")
                    .font(.system(size: 14, weight: .bold))
                Text("Items")
                    .font(.system(size: 10, weight: .light))
                    .foregroundStyle(.neutral500)
            }
            .frame(maxWidth: .infinity)
            .padding(4)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(.neutral200)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.white, lineWidth: 1.5)
        }
        .padding(6)
    }
}
//
//#Preview(traits: .sizeThatFitsLayout, body: {
//    BoxesList()
//        .background(.red.opacity(0.5))
//})
