import SwiftUI
import Foundation

struct PlayerProfilesView: View {
    @EnvironmentObject private var store: AppStore
    @State private var searchText = ""

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
                                PlayerTile(profile: player)
                                    .onTapGesture {
                                        store.deactivatePlayer(player)
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
                            PlayerTile(profile: profile)
                                .opacity(store.activePlayers.contains(profile) ? 0.4 : 1)
                                .onTapGesture {
                                    store.activatePlayer(profile)
                                }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Players")
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    CreatePlayerView()
                        .environmentObject(store)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
