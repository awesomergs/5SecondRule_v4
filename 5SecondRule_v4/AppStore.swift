import Foundation
import SwiftUI
import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published var decks: [Deck] = Deck.sample
    @Published var leaderboard: [String: Int] = [:]   // playerName -> totalWins/points
    
    @Published var savedPlayers: [String] = []
    private let playersKey = "saved_players_v1"
    
    @Published var roundsPerPlayer: Int = 7
    
    @Published var playerProfiles: [PlayerProfile] = []
    @Published var activePlayers: [PlayerProfile] = []
    
    private let profilesKey = "player_profiles_v1"
    private let activePlayersKey = "active_player_ids_v1"


    init() {
        loadLeaderboard()
        loadPlayerProfiles()
        loadActivePlayers()
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
    
    func loadProfiles() {
        guard
            let data = UserDefaults.standard.data(forKey: profilesKey),
            let decoded = try? JSONDecoder().decode([PlayerProfile].self, from: data)
        else { return }

        playerProfiles = decoded
    }

    func saveProfiles() {
        if let data = try? JSONEncoder().encode(playerProfiles) {
            UserDefaults.standard.set(data, forKey: profilesKey)
        }
    }
    
    func addProfile(_ profile: PlayerProfile) {
        playerProfiles.append(profile)
        savePlayerProfiles()
    }


    func removeProfile(_ profile: PlayerProfile) {
        playerProfiles.removeAll { $0.id == profile.id }
        activePlayers.removeAll { $0.id == profile.id }

        savePlayerProfiles()
        saveActivePlayers()
    }


    
    func activatePlayer(_ profile: PlayerProfile) {
        guard !activePlayers.contains(profile) else { return }
        activePlayers.append(profile)
        saveActivePlayers()
    }


    func deactivatePlayer(_ profile: PlayerProfile) {
        activePlayers.removeAll { $0.id == profile.id }
        saveActivePlayers()
    }


    func clearActivePlayers() {
        activePlayers.removeAll()
        saveActivePlayers()
    }

    
    private func savePlayerProfiles() {
        if let data = try? JSONEncoder().encode(playerProfiles) {
            UserDefaults.standard.set(data, forKey: profilesKey)
        }
    }

    private func loadPlayerProfiles() {
        guard
            let data = UserDefaults.standard.data(forKey: profilesKey),
            let decoded = try? JSONDecoder().decode([PlayerProfile].self, from: data)
        else { return }

        playerProfiles = decoded
    }
    
    private func saveActivePlayers() {
        let ids = activePlayers.map { $0.id.uuidString }
        UserDefaults.standard.set(ids, forKey: activePlayersKey)
    }

    private func loadActivePlayers() {
        guard let storedIDs = UserDefaults.standard.stringArray(forKey: activePlayersKey) else {
            return
        }

        let idSet = Set(storedIDs)

        activePlayers = playerProfiles.filter {
            idSet.contains($0.id.uuidString)
        }
    }



}
