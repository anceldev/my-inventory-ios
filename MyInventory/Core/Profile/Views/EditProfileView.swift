//
//  EditProfileView.swift
//  MyInventory
//
//  Created by Ancel Dev account on 28/11/24.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(\.dismiss) var dismiss
    var user: User
    @State private var newName: String
    @State private var newUsername: String
    @State private var showProfilePicker = false
    @State private var selectedProfile: AvatarImage?
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    init(for user: User) {
        self.user = user
        self._newName = State(initialValue: user.name)
        self._newUsername = State(initialValue: user.username)
        self._selectedProfile = State(initialValue: user.avatar)
    }
    var body: some View {
        VStack {
            VStack {
                if selectedProfile != nil {
                    Image(selectedProfile!.rawValue)
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 140, height: 140)
                        .clipShape(.circle)
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 5)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "pencil")
                                .padding(8)
                                .background(.green)
                                .clipShape(.circle)
                                .onTapGesture {
                                    showProfilePicker.toggle()
                                }
                        }
                } else {
                    Image(AvatarImage.avatarDefault.rawValue)
                        .resizable()
                        .padding()
                        .background(.orange)
                        .foregroundStyle(.white)
                        .frame(width: 140, height: 140)
                        .clipShape(.circle)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "pencil")
                                .padding(4)
                                .background(.green)
                                .clipShape(.circle)
                                .onTapGesture {
                                    showProfilePicker.toggle()
                                }
                        }
                }
            }
            .padding(.top, 20)
            
            
            VStack(spacing: 16) {
                TextField("Nombre", text: $newName)
                    .customTextField("Nombre")
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .autocorrectionDisabled()
                TextField("Nombre de usuario", text: $newUsername)
                    .customTextField("Usuario")
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .autocorrectionDisabled()
//                    .focused($focused, equals: .email)
//                    .onSubmit {
//                        focused = .password
//                    }
                Spacer()
            }
            .padding(24)
            
            HStack(spacing: 32) {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Cancelar")
                        .foregroundStyle(.white)
                }

                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.redBase)
                .clipShape(.capsule)
                
                Button {
                    updateProfile()
                } label: {
                    Text("Guardar")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.greenBase)
                .clipShape(.capsule)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.neutral100)
        .sheet(isPresented: $showProfilePicker) {
            VStack(spacing: 20) {
                VStack {
                    Text("Selecciona tu avatar")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.neutral700)                }
                LazyVGrid(columns: columns) {
                    ForEach(AvatarImage.allCases, id:\.self) { profile in
                        if profile != .avatarDefault {
                            Image(profile.rawValue)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Circle()
                                        .stroke(selectedProfile == profile ? .pink : .clear, lineWidth: 3)
                                }
                                .onTapGesture {
                                    withAnimation(.bouncy) {
                                        selectedProfile = profile
                                    }
                                }
                        }
                    }
                }
                .backgroundStyle(.red)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(480)])
            .presentationBackground(.neutral200)
        }
    }
    private func updateProfile() {
        Task {
            do {
                print(selectedProfile?.rawValue ?? "NO selected")
                print(newName)
                print(newUsername)
                let newUserData = User(
                    id: user.id,
                    name: newName,
                    username: newUsername,
                    email: user.email,
                    avatar: selectedProfile ?? .avatarDefault
                )
                try await AWClient.updateDocument(
                    collection: .users,
                    model: newUserData,
                    docId: newUserData.id
                )
                authVM.user?.name = newName
                authVM.user?.username = newUsername
                authVM.user?.avatar = selectedProfile ?? .avatarDefault
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    EditProfileView(for: User.preview)
        .environment(AuthViewModel())
}
