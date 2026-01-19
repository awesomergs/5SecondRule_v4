import SwiftUI

struct NewGameView: View {
    @EnvironmentObject private var store: AppStore

    @State private var playerName: String = ""
    @State private var players: [String] = []
    

    private let roundOptions = [5, 10, 15]
    @State private var selectedRounds: Int = 10
    
    private enum RoundChoice: String, CaseIterable, Identifiable {
        case three = "3"
        case seven = "7"
        case ten = "10"
        case custom = "Custom"
        var id: String { rawValue }
    }

    @State private var roundChoice: RoundChoice = .seven
    @State private var customRoundsText: String = ""
    
    private var resolvedRoundsPerPlayer: Int? {
        switch roundChoice {
        case .three: return 3
        case .seven: return 7
        case .ten: return 10
        case .custom:
            let trimmed = customRoundsText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let n = Int(trimmed), n > 0, n <= 100 else { return nil }
            return n
        }
    }


    var body: some View {
        List {
            Section("Game Length") {
                Picker("Rounds per player", selection: $roundChoice) {
                    Text("3").tag(RoundChoice.three)
                    Text("7").tag(RoundChoice.seven)
                    Text("10").tag(RoundChoice.ten)
                    Text("Custom").tag(RoundChoice.custom)
                }
                .pickerStyle(.segmented)

                if roundChoice == .custom {
                    TextField("Enter rounds per player (e.g., 5)", text: $customRoundsText)
                        .keyboardType(.numberPad)
                }

                if roundChoice == .custom {
                    Text("Enter a valid number (1–100).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }


            Section("Players") {
                HStack {
                    TextField("Add player name", text: $playerName)
                        .textInputAutocapitalization(.words)

                    Button("Add") { addPlayer() }
                        .disabled(playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                if players.isEmpty {
                    Text("Add at least 2 players.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(players, id: \.self) { p in
                        Text(p)
                    }
                    .onDelete { idx in
                        players.remove(atOffsets: idx)
                    }
                }
            }

            Section {
                NavigationLink("Start") {
                    GameView(initialState: store.startNewGame(
                        players: players,
                        roundsPerPlayer: resolvedRoundsPerPlayer ?? 7
                    ))
                    .environmentObject(store)
                }
                .disabled(players.count < 2 || resolvedRoundsPerPlayer == nil)

            }
        }
        .navigationTitle("New Game")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") { players.removeAll() }
                    .disabled(players.isEmpty)
            }
        }
        .onAppear {
            if players.isEmpty {
                players = store.savedPlayers
            }
        }

    }

    private func addPlayer() {
        let cleaned = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty else { return }
        guard !players.contains(cleaned) else { playerName = ""; return }

        players.append(cleaned)
        store.addPlayer(cleaned)
        playerName = ""
    }
}
