//
//  ProfileView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct ProfileView: View {

    @Environment(AuthViewModel.self) var authVM
    @Environment(AccountViewModel.self) var accountVM
    @Environment(\.dismiss) var dismiss
    @State private var suggestionsVM = SuggestionsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack {
                    Image(accountVM.account.avatar.rawValue)
                        .resizable()
                        .aspectRatio(1/1, contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 5)
                        }
                    VStack(spacing: 4) {
                        Text(accountVM.account.name.capitalized)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.neutral600)
                        Text("@\(accountVM.account.username.lowercased())")
                            .foregroundStyle(.neutral500)
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16  ))
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                Divider()
                
                VStack(spacing: 16) {
                    ScrollView(.vertical) {
                        NavigationLink {
                            Text("ShareQR")
                        } label: {
                            ProfileRow("Compartir QR", description: "Comparte tu perfil con otros") {
                                ItemRowImage(
                                    systemName: "qrcode",
                                    color: Color.pinkDark,
                                    size: .init(width: 40, height: 40)
                                )
                            }
                        }
                        
                        NavigationLink {
                            EditProfileView(for: accountVM.account)
                        } label: {
                            ProfileRow("Editar perfil", description: "Editar ajustes de perfil") {
                                EditProfileRowImage()
                            }
                        }
                        NavigationLink {
                            UsersListView()
#if DEBUG
                                .environment(authVM)
#endif
                        } label: {
                            ProfileRow("Mis amigos", description: "Lista de amigos") {
                                MyFriendsRowImage()
                            }
                        }
                        NavigationLink {
                            ImprovementsView()
                                .environment(suggestionsVM)
                        } label: {
                            ProfileRow("Mejoras", description: "Sugiere mejoras al desarrollador") {
                                ItemRowImage(
                                    systemName: "lightbulb.max",
                                    color: .yellowBase,
                                    size: .init(
                                        width: 35,
                                        height: 40
                                    )
                                )
                            }
                        }
                        Link(destination: URL(string: "https://anceldev.com")!) {
                            ProfileRow("Web", description: "Ver términos de uso") {
                                ItemRowImage(
                                    systemName: "network",
                                    color: .tealBase,
                                    size: .init(width: 40, height: 40)
                                )
                            }
                        }
                        Link(destination: URL(string: "https://anceldev.com")!) {
                            ProfileRow("Terminos de uso", description: "Ver términos de uso") {
                                ItemRowImage(
                                    systemName: "text.document",
                                    color: .pinkDarker,
                                    size: .init(width: 28, height: 40)
                                )
                            }
                        }
                        Link(destination: URL(string: "https://anceldev.com")!) {
                            ProfileRow("Privacidad", description: "Ver Política de privacidad") {
                                ItemRowImage(
                                    systemName: "lock.document",
                                    color: .tealDarker,
                                    size: .init(width: 28, height: 40)
                                )
                            }
                        }
                        Button {
                            signOut()
                        } label: {
                            ProfileRow("Cerrar sesión", description: "Cerrar sesión en el dispositivo") {
                                ItemRowImage(
                                    systemName: "door.left.hand.open",
                                    color: .redDark,
                                    size: .init(width: 25, height: 40)
                                )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)

                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .safeAreaPadding(.top, 30)
            .padding([.horizontal], 24)
            .background(.neutral100)
        }
    }
    private func signOut() {
        Task {
            await authVM.signOut()
        }
    }
    
    @ViewBuilder
    func MyFriendsRowImage() -> some View {
        ZStack {
            Image(AvatarImage.avatarMen1.rawValue)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(.circle)
                .overlay {
                    Circle().stroke(.white, lineWidth: 3)
                }
                .rotationEffect(.degrees(-15))
                .offset(x: -30, y: 0)
            Image(AvatarImage.avatarMen2.rawValue)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(.circle)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 3)
                }
                .offset(x: 0, y: -10)
                .opacity(0.95)
            Image(AvatarImage.avatarWomen2.rawValue)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(.circle)
                .overlay {
                    Circle()
                        .stroke(.white, lineWidth: 3)
                }
                .offset(x: 30, y: 0)
                .opacity(0.95)
        }
        .offset(x: -20, y: 5)
    }
    @ViewBuilder
    func EditProfileRowImage() -> some View {
        Image(AvatarImage.avatarMen1.rawValue)
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(.circle)
            .overlay {
                Circle().stroke(.white, lineWidth: 3)
            }
            .rotationEffect(.degrees(-15))
    }
    @ViewBuilder
    func ItemRowImage(systemName: String, color: Color, size: CGSize) -> some View {
            Image(systemName: systemName)
                .resizable()
                .frame(width: size.width, height: size.height)
                .rotationEffect(.degrees(15))
                .foregroundStyle(color)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(AuthViewModel())
            .environment(AccountViewModel(userId: "675cdc1a1abc2861d5c1"))
    }
}
