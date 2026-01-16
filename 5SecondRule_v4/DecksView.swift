import SwiftUI
import Combine

struct DecksView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        List {
            Section("Decks in Rotation") {
                ForEach($store.decks) { $deck in
                    HStack(spacing: 12) {
                        Text(deck.emoji).font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(deck.title).font(.headline)
                            Text("\(deck.questions.count) prompts")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $deck.isEnabled)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                NavigationLink {
                    NewGameView()
                        .environmentObject(store)
                } label: {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text("Start New Game")
                    }
                    .font(.headline)
                }
                .disabled(store.decks.allSatisfy { !$0.isEnabled })
            } footer: {
                if store.decks.allSatisfy({ !$0.isEnabled }) {
                    Text("Turn on at least one deck to start a game.")
                }
            }

//            Section("Leaderboard") {
//                NavigationLink("View Leaderboard") {
//                    LeaderboardView()
//                        .environmentObject(store)
//                }
//            }
        }
        .navigationTitle("5 Second Rule")
    }
}
