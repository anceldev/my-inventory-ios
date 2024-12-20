//
//  ProfileRow.swift
//  MyInventory
//
//  Created by Ancel Dev account on 19/12/24.
//

import SwiftUI

struct ProfileRow: View {
    let rowTitle: String
    let description: String
    let trailingView: () -> AnyView
    init(_ rowTitle: String, description: String, @ViewBuilder trailingView: @escaping () -> some View) {
        self.rowTitle = rowTitle
        self.description = description
        self.trailingView = { AnyView(trailingView()) }
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(rowTitle)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.neutral600)
                Text(description)
                    .foregroundStyle(.neutral400)
                    .font(.system(size: 14))
            }
            Spacer()
//            HStack(alignment: .center) {
                trailingView()
//            }
            //            VStack {
            //                Image(AvatarImage.avatarMen1.rawValue)
            //                    .clipShape(.circle)
            //                    .overlay {
            //                        Circle()
            //                            .stroke(.white, lineWidth: 3)
            //                    }
            //                    .rotationEffect(.degrees(-15))
            //            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        //        .frame(height: 110, alignment: .topLeading)
        .background(.neutral200)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    VStack {
//        ProfileRow("Editar perfil", description: "Descripcion de editar", trailingView: {
//            Image(AvatarImage.avatarMen1.rawValue)
//                .resizable()
//                .frame(width: 60, height: 60)
//                .clipShape(.circle)
//                .overlay {
//                    Circle().stroke(.white, lineWidth: 3)
//                }
//                .rotationEffect(.degrees(-15))
//        })
//        .padding(24)
        
        ProfileRow("Web", description: "Ver web") {
            Image(systemName: "network")
                .resizable()
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(15))
                .foregroundStyle(.tealBase)
        }
        
//        ProfileRow("Mis Amigos", description: "Lista de amigos", trailingView: {
//            ZStack {
//                Image(AvatarImage.avatarMen1.rawValue)
//                    .resizable()
//                    .frame(width: 60, height: 60)
//                    .clipShape(.circle)
//                    .overlay {
//                        Circle().stroke(.white, lineWidth: 3)
//                    }
//                    .rotationEffect(.degrees(-15))
//                    .offset(x: -30, y: 0)
//                Image(AvatarImage.avatarMen2.rawValue)
//                    .resizable()
//                    .frame(width: 60, height: 60)
//                    .clipShape(.circle)
//                    .overlay {
//                        Circle()
//                            .stroke(.white, lineWidth: 3)
//                    }
//                    .offset(x: 0, y: -10)
//                    .opacity(0.95)
//                Image(AvatarImage.avatarWomen2.rawValue)
//                    .resizable()
//                    .frame(width: 60, height: 60)
//                    .clipShape(.circle)
//                    .overlay {
//                        Circle()
//                            .stroke(.white, lineWidth: 3)
//                    }
//                    .offset(x: 30, y: 0)
//                    .opacity(0.95)
//            }
//            .offset(x: -10)
//        })
//        .padding(24)
    }
}

