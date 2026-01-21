import SwiftUI
import Combine
import UIKit


struct GameView: View {
    @EnvironmentObject private var store: AppStore

    @State private var state: GameState
    @State private var timeLeft: Int = 5
    @State private var isRunning: Bool = false
    @State private var showTimeUp: Bool = false
    
    
    @Environment(\.dismiss) private var dismiss


    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(initialState: GameState) {
        _state = State(initialValue: initialState)
    }

    var body: some View {
        VStack(spacing: 18) {

            if !state.isGameOver {
                header
                    .transition(.opacity)
            }

            Spacer(minLength: 0)

            questionCard

            if !state.isGameOver {
                timerRow
                actionButtons
            }

            Spacer(minLength: 0)
        }
        .animation(.easeInOut(duration: 0.25), value: state.isGameOver)
        .padding()
        .navigationTitle("Game")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { _ in
            guard isRunning else { return }
            tick()
        }
        .alert("Time’s up!", isPresented: $showTimeUp) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Mark Correct or Pass, then go next.")
        }
        
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("Current Player")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let profile = currentPlayerProfile {
                VStack(spacing: 6) {
                    avatarView(for: profile)

                    Text(profile.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: state.currentPlayerIndex)
                .transition(.scale.combined(with: .opacity))
            } else {
                Text(state.currentPlayer)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
        }
    }

    

    private var questionCard: some View {
        Group {
            if state.isGameOver {
                gameOverCard
            } else if let q = state.currentQuestion {
                VStack(spacing: 10) {
                    Text("Prompt")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(q.prompt)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(), value: state.currentQuestionIndex)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                VStack(spacing: 10) {
                    Text("Out of prompts!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Enable more decks or add more questions.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var winningPlayers: [String] {
        let maxScore = state.scores.values.max() ?? 0
        return state.players.filter {
            state.scores[$0, default: 0] == maxScore
        }
    }

    private func profile(for playerName: String) -> PlayerProfile? {
        store.playerProfiles.first { $0.name == playerName }
    }

    
    private var gameOverCard: some View {
        VStack(spacing: 16) {

            // MARK: - Winner Section
            VStack {
                if winningPlayers.count == 1,
                   let winner = winningPlayers.first {

                    winnerHeader(for: winner)

                } else {
                    VStack(spacing: 6) {
                        Text("It’s a Tie!")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(winningPlayers.joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .animation(
                .spring(response: 0.5, dampingFraction: 0.7),
                value: winningPlayers
            )

            Divider()

            // MARK: - Scoreboard (your existing logic)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(
                    state.players.sorted {
                        let s0 = state.scores[$0, default: 0]
                        let s1 = state.scores[$1, default: 0]
                        return s0 == s1 ? $0 < $1 : s0 > s1
                    },
                    id: \.self
                ) { p in
                    HStack {
                        Text(p)
                        Spacer()
                        Text("\(state.scores[p, default: 0])")
                            .monospacedDigit()
                            .fontWeight(.semibold)
                    }
                }
            }

            Button("Back to Home Screen") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder
    private func winnerHeader(for playerName: String) -> some View {
        let profile = profile(for: playerName)

        VStack(spacing: 6) {
            ZStack(alignment: .top) {

                // Crown
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
                    .font(.title)
                    .offset(y: -18)

                // Avatar
                if let data = profile?.imageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.yellow, lineWidth: 3)
                        )
                        .shadow(radius: 6)
                } else {
                    Circle()
                        .fill(.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .overlay {
                            Text(String(playerName.prefix(1)))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                }
            }

            Text(playerName)
                .font(.title2)
                .fontWeight(.bold)

            Text("Winner")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }



    private var gameplayDisabled: Bool {
        state.isGameOver || state.currentQuestion == nil
    }


    private var timerRow: some View {
        VStack(spacing: 8) {
            Text("\(timeLeft)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(
                    timeLeft <= 1 ? .red :
                    timeLeft <= 3 ? .orange :
                    .primary
                )
                .scaleEffect(timeLeft <= 2 ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: timeLeft)


            Button {
                toggleTimer()
            } label: {
                Label(isRunning ? "Pause" : "Start 5s Timer",
                      systemImage: isRunning ? "pause.fill" : "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(gameplayDisabled)
        }
    }


    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                mark(correct: false)
                nextTurn()
            } label: {
                Label("Pass", systemImage: "xmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                mark(correct: true)
                nextTurn()
            } label: {
                Label("Correct", systemImage: "checkmark.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .disabled(gameplayDisabled)
        .opacity(gameplayDisabled ? 0.5 : 1)
    }


//    private var nextTurnRow: some View {
//        Button {
//            nextTurn()
//        } label: {
//            Label("Next Turn", systemImage: "arrow.right.circle.fill")
//                .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.bordered)
//        .disabled(gameplayDisabled)
//    }


    private func toggleTimer() {
        if isRunning {
            isRunning = false
        } else {
            // restarting from 5 if it already hit 0
            if timeLeft <= 0 { timeLeft = 5 }
            isRunning = true
        }
    }

    private func tick() {
        timeLeft -= 1

        if timeLeft <= 3 && timeLeft > 0 {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }

        if timeLeft <= 0 {
            timeLeft = 0
            isRunning = false
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            showTimeUp = true
        }
    }


    private func mark(correct: Bool) {
        if correct {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            state.addPointToCurrentPlayer()
        } else {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }


    private func nextTurn() {
        isRunning = false
        timeLeft = 5

        state.advanceTurn()

        if state.isGameOver {
            isRunning = false
            timeLeft = 5
        }
    }
    
    private var currentPlayerProfile: PlayerProfile? {
        store.playerProfiles.first {
            $0.name == state.currentPlayer
        }
    }
    
    @ViewBuilder
    private func avatarView(for profile: PlayerProfile) -> some View {
        if let data = profile.imageData,
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.primary.opacity(0.2), lineWidth: 2)
                )
                .shadow(radius: 4)
        } else {
            Circle()
                .fill(.gray.opacity(0.3))
                .frame(width: 72, height: 72)
                .overlay {
                    Text(String(profile.name.prefix(1)))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
        }
    }



}
