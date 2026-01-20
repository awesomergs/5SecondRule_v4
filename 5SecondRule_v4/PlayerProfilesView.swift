import SwiftUI

struct PlayerProfilesView: View {
    @EnvironmentObject private var store: AppStore

    @State private var searchText = ""
    @State private var isEditing = false
    @State private var playerToDelete: PlayerProfile?

    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 16)
    ]

    private var filteredProfiles: [PlayerProfile] {
        if searchText.isEmpty { return store.playerProfiles }
        return store.playerProfiles.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Active Players
                if !store.activePlayers.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Active Players")
                                .font(.headline)

                            Spacer()

                            Button("Clear") {
                                store.clearActivePlayers()
                            }
                        }

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(store.activePlayers) { player in
                                PlayerTile(
                                    profile: player,
                                    isEditing: isEditing,
                                    isActive: true
                                )
                                .onTapGesture {
                                    if isEditing {
                                        playerToDelete = player
                                    } else {
                                        store.deactivatePlayer(player)
                                    }
                                }
                            }
                        }
                    }
                }

                // MARK: - All Profiles
                VStack(alignment: .leading, spacing: 8) {
                    Text("All Players")
                        .font(.headline)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredProfiles) { profile in
                            PlayerTile(
                                profile: profile,
                                isEditing: isEditing,
                                isActive: store.activePlayers.contains(profile)
                            )
                            .opacity(store.activePlayers.contains(profile) ? 0.4 : 1)
                            .onTapGesture {
                                if isEditing {
                                    playerToDelete = profile
                                } else {
                                    store.activatePlayer(profile)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(isEditing ? "Edit Players" : "Players")
        .searchable(text: $searchText)
        .toolbar {

            // Edit / Done
            ToolbarItem(placement: .topBarLeading) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation(.spring()) {
                        isEditing.toggle()
                    }
                }
            }

            // Add Player
            ToolbarItem(placement: .topBarTrailing) {
                if !isEditing {
                    NavigationLink {
                        CreatePlayerView()
                            .environmentObject(store)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .alert("Delete Player?",
               isPresented: Binding(
                get: { playerToDelete != nil },
                set: { if !$0 { playerToDelete = nil } }
               )) {

            Button("Delete", role: .destructive) {
                if let player = playerToDelete {
                    store.removeProfile(player)
                }
                playerToDelete = nil
            }

            Button("Cancel", role: .cancel) {
                playerToDelete = nil
            }

        } message: {
            Text("This will remove the player profile permanently.")
        }
    }
}
