import SwiftUI
import Combine

struct DecksView: View {
    @EnvironmentObject private var store: AppStore

    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach($store.decks) { $deck in
                    DeckCardView(deck: deck)
                        .scaleEffect(deck.isEnabled ? 1.0 : 0.985)
                        .animation(.easeInOut(duration: 0.15), value: deck.isEnabled)
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            deck.isEnabled.toggle()
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
        .navigationTitle("Decks")
    }
}
