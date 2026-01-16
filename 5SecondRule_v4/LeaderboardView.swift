import SwiftUI
import Combine

struct LeaderboardView: View {
    @EnvironmentObject private var store: AppStore

    var sorted: [(String, Int)] {
        store.leaderboard
            .map { ($0.key, $0.value) }
            .sorted { a, b in a.1 > b.1 }
    }

    var body: some View {
        List {
            if sorted.isEmpty {
                Text("No scores yet — play a round!")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(sorted.enumerated()), id: \.offset) { idx, row in
                    HStack {
                        Text("#\(idx + 1)")
                            .foregroundStyle(.secondary)
                            .frame(width: 40, alignment: .leading)

                        Text(row.0)
                            .font(.headline)

                        Spacer()

                        Text("\(row.1)")
                            .font(.headline)
                            .monospacedDigit()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Leaderboard")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset") {
                    store.leaderboard = [:]
                    // trigger persistence
                    store.awardPoint(to: "__noop__")
                    store.leaderboard["__noop__"] = nil
                }
                .disabled(store.leaderboard.isEmpty)
            }
        }
    }
}
