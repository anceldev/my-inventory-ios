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
        LazyVGrid(columns: columns) {
            ForEach(boxes) { box in
                VStack(alignment: .leading, spacing: 16) {
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
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
//                .frame(minHeight: 100, alignment: .topLeading)
                .padding(15)
                .background(.neutral200)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
    }
}
