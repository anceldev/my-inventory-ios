//
//  ProfileView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(\.dismiss) var dismiss
    @State private var suggestionsVM = SuggestionsViewModel()
    
    var profileImage: Image {
        if let avatar = authVM.user?.avatar {
            return Image(avatar.rawValue)
        }
        return Image(AvatarImage.avatarDefault.rawValue)
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack {
                    profileImage
                        .resizable()
                        .aspectRatio(1/1, contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 5)
                        }
                    VStack(spacing: 4) {
                        Text(authVM.user?.name.capitalized ?? "No-name")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.neutral600)
                        Text("@\(authVM.user?.username ?? "NO-USERNAME")")
                            .foregroundStyle(.neutral500)
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16  ))
                .padding(.horizontal, 20)
//                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
                Divider()
                
                VStack(spacing: 16) {
                    ScrollView(.vertical) {
                        NavigationLink {
                            Text("ShareQR")
                        } label: {
                            ProfileRow("Compartir QR", description: "Comparte tu perfil con otros") {
                                ShareQRRowImage()
                            }
                        }
                        
                        NavigationLink {
                            EditProfileView(for: authVM.user ?? User.preview)
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
    func ShareQRRowImage() -> some View {
        Image(systemName: "qrcode")
            .resizable()
            .frame(width: 40, height: 40, alignment: .center)
            .rotationEffect(.degrees(15))
    }
    @ViewBuilder
    func SignOutRowImage() -> some View {
        Image(systemName: "door.left.hand.open")
            .resizable()
            .frame(width: 25, height: 40, alignment: .center)
            .rotationEffect(.degrees(15))
            .foregroundStyle(.redDark)
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
    let authVM = AuthViewModel()
    authVM.user = User.preview
    return NavigationStack {
        ProfileView()
            .environment(authVM)
    }
}
