import SwiftUI

struct PlayersView: View {
    @EnvironmentObject private var store: AppStore
    @Binding var players: [String]

    @State private var newPlayer: String = ""

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Add player name", text: $newPlayer)
                        .textInputAutocapitalization(.words)

                    Button("Add") { addPlayer() }
                        .disabled(newPlayer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            Section("Players") {
                if players.isEmpty {
                    Text("No players yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(players, id: \.self) { p in
                        Text(p)
                    }
                    .onDelete { players.remove(atOffsets: $0) }
                }
            }
        }
        .navigationTitle("Players")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") { players.removeAll() }
                    .disabled(players.isEmpty)
            }
        }
    }

    private func addPlayer() {
        let cleaned = newPlayer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty, !players.contains(cleaned) else {
            newPlayer = ""
            return
        }

        players.append(cleaned)
        store.addPlayer(cleaned)
        newPlayer = ""
    }
}
