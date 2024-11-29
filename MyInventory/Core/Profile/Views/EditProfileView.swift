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
    @State private var selectedProfile: ProfileImage?
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    init(for user: User) {
        self.user = user
        self._newName = State(initialValue: user.name)
        self._newUsername = State(initialValue: user.username)
        self._selectedProfile = State(initialValue: user.profileImage)
    }
    var body: some View {
        VStack {
            if selectedProfile != nil {
                Image(selectedProfile!.rawValue)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
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
            } else {
                Image(systemName: "person")
                    .resizable()
                    .padding()
                    .background(.orange)
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
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
            
            
            VStack(spacing: 16) {
                CustomTextField("Name", text: $newName, fieldType: .name)
                CustomTextField("Username", text: $newUsername, fieldType: .name)
                Spacer()
            }
            .padding(24)
            
            HStack(spacing: 32) {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    updateProfile()
                } label: {
                    Text("Update")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .background(.bgWeak100)
        .sheet(isPresented: $showProfilePicker) {
            VStack(spacing: 20) {
                VStack {
                    Text("Select profile image")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.gray.opacity(0.15))
                LazyVGrid(columns: columns) {
                    ForEach(ProfileImage.allCases, id:\.self) { profile in
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
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(500)])
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
                    profileImage: selectedProfile
                )
                try await AWClient.updateDocument(
                    collection: .users,
                    model: newUserData,
                    docId: newUserData.id
                )
                authVM.user?.name = newName
                authVM.user?.username = newUsername
                authVM.user?.profileImage = selectedProfile
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
