import SwiftUI

struct DeckCardView: View {
    let deck: Deck

    var body: some View {
        Group {
            if let key = deck.imageKey {
                Image(deck.isEnabled
                      ? "\(key)_on"
                      : "\(key)_off")
                    .resizable()
                    .scaledToFit()
            } else {
                fallbackView
            }
        }
        .opacity(deck.isEnabled ? 1.0 : 0.85)
        .animation(.easeInOut(duration: 0.4), value: deck.isEnabled)
    }

    private var fallbackView: some View {
        VStack {
            Text(deck.emoji).font(.largeTitle)
            Text(deck.title).font(.headline)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
    }
}
