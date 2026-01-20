import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore

    private enum RoundChoice: String, CaseIterable, Identifiable {
        case three = "3"
        case seven = "7"
        case ten = "10"
        case custom = "Custom"
        var id: String { rawValue }
    }

    @State private var roundChoice: RoundChoice = .seven
    @State private var customRoundsText: String = ""

    private var resolvedRounds: Int? {
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

            // MARK: - Game Length
            Section("Game Length") {
                Picker("Rounds per player", selection: $roundChoice) {
                    Text("3").tag(RoundChoice.three)
                    Text("7").tag(RoundChoice.seven)
                    Text("10").tag(RoundChoice.ten)
                    Text("Custom").tag(RoundChoice.custom)
                }
                .pickerStyle(.segmented)

                if roundChoice == .custom {
                    TextField("Enter rounds (1–100)", text: $customRoundsText)
                        .keyboardType(.numberPad)
                }
            }

            // MARK: - Navigation
            Section {
                NavigationLink {
                    PlayerProfilesView()
                        .environmentObject(store)
                } label: {
                    Label("Players", systemImage: "person.2.fill")
                }

                NavigationLink {
                    DecksView()
                        .environmentObject(store)
                } label: {
                    Label("Decks", systemImage: "rectangle.stack.fill")
                }
            }

            // MARK: - Start Game
            Section {
                NavigationLink {
                    GameView(
                        initialState: store.startNewGame(
                            players: store.activePlayers.map { $0.name },
                            roundsPerPlayer: resolvedRounds ?? 7
                        )
                    )
                    .environmentObject(store)
                } label: {
                    Label("Start Game", systemImage: "play.circle.fill")
                        .font(.headline)
                }
                .disabled(store.activePlayers.count < 2 || resolvedRounds == nil)

            } footer: {
                if store.activePlayers.count < 2 {
                    Text("Select at least 2 players to start.")
                }
            }
        }
        .navigationTitle("5 Second Rule")
    }
}
