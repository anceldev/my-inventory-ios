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
    var body: some View {
        NavigationStack {
        
            VStack(spacing: 24) {
                ZStack {
                    Image(.previewBackdrop)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 0.5)
                        .clipped()
                    VStack(alignment: .center) {
                        if let profile = authVM.user?.profileImage {
                            Image(profile.rawValue)
                                .resizable()
                                .frame(width: 80, height: 80)
                        } else {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        Text("@\(authVM.user?.username ?? "NO-NAME")")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .shadow(color: .black, radius: 1)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                List {
                    Section{
                        NavigationLink {
                            EditProfileView(for: authVM.user ?? User.preview)
                                .environment(authVM)
                        } label: {
                            HStack {
                                Label("person", systemImage: "person.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                                Text("Edit profile")
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 16))
                        Button {
                            signOut()
                        } label: {
                            
                            HStack(alignment: .center) {
                                Label("person", systemImage: "rectangle.portrait.and.arrow.right")
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle(.red)
                                    .padding(.leading, 5)
                                Text("Sign out")
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 16))
                    } header: {
                        Text("Account")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .textCase(.none)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .safeAreaPadding(.top, 20)
            .background(.bgWeak100)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }

                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func signOut() {
        Task {
            await authVM.signOut()
        }
    }
}


#Preview {
    NavigationStack {
        ProfileView()
            .environment(AuthViewModel())
    }
}
