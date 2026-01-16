import SwiftUI
import Combine

struct GameView: View {
    @EnvironmentObject private var store: AppStore

    @State private var state: GameState
    @State private var timeLeft: Int = 5
    @State private var isRunning: Bool = false
    @State private var showTimeUp: Bool = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(initialState: GameState) {
        _state = State(initialValue: initialState)
    }

    var body: some View {
        VStack(spacing: 18) {
            header

            Spacer(minLength: 0)

            questionCard

            timerRow

            actionButtons

            Spacer(minLength: 0)

//            nextTurnRow
        }
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
        VStack(spacing: 6) {
            Text("Current Player")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(state.currentPlayer)
                .font(.largeTitle)
                .fontWeight(.bold)
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
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            } else {
                // If you run out of prompts before rounds end: (for testing rn)
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
    
    private var gameOverCard: some View {
        VStack(spacing: 12) {
            Text("Game Over")
                .font(.title)
                .fontWeight(.bold)

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
            .padding(.top, 6)

            NavigationLink("Back to Home Screen") {
                DecksView().environmentObject(store)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var gameplayDisabled: Bool {
        state.isGameOver || state.currentQuestion == nil
    }


    private var timerRow: some View {
        VStack(spacing: 8) {
            Text("\(timeLeft)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()

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
        if timeLeft <= 0 {
            timeLeft = 0
            isRunning = false
            showTimeUp = true
        }
    }

    private func mark(correct: Bool) {
        if correct {
            state.addPointToCurrentPlayer()
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

}
