import Foundation
import SwiftUI
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published var decks: [Deck] = Deck.sample
    @Published var leaderboard: [String: Int] = [:]   // playerName -> totalWins/points
    
    @Published var savedPlayers: [String] = []
    private let playersKey = "saved_players_v1"

    init() {
        loadLeaderboard()
        loadPlayers()
    }

    func startNewGame(players: [String], roundsPerPlayer: Int) -> GameState {
        let enabledDecks = decks.filter { $0.isEnabled }
        let questions = enabledDecks.flatMap { $0.questions }.shuffled()

        var initialScores: [String: Int] = [:]
        for p in players { initialScores[p] = 0 }

        return GameState(
            players: players,
            questions: questions,
            roundsPerPlayer: roundsPerPlayer,
            turnsPlayed: 0,
            currentPlayerIndex: 0,
            currentQuestionIndex: 0,
            scores: initialScores
        )
    }
    
    func addPlayer(_ name: String) {
            guard !savedPlayers.contains(name) else { return }
            savedPlayers.append(name)
            savePlayers()
        }

        func removePlayer(_ name: String) {
            savedPlayers.removeAll { $0 == name }
            savePlayers()
        }

        private func savePlayers() {
            UserDefaults.standard.set(savedPlayers, forKey: playersKey)
        }

        private func loadPlayers() {
            if let stored = UserDefaults.standard.array(forKey: playersKey) as? [String] {
                savedPlayers = stored
            }
        }


    func awardPoint(to player: String) {
        leaderboard[player, default: 0] += 1
        saveLeaderboard()
    }

    // MARK: - Persistence (UserDefaults)

    private let leaderboardKey = "leaderboard_points_v1"

    private func saveLeaderboard() {
        if let data = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(data, forKey: leaderboardKey)
        }
    }

    private func loadLeaderboard() {
        guard
            let data = UserDefaults.standard.data(forKey: leaderboardKey),
            let decoded = try? JSONDecoder().decode([String: Int].self, from: data)
        else { return }

        leaderboard = decoded
    }
}
