import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var store = AppStore()

    var body: some View {
        NavigationStack {
            DecksView()
                .environmentObject(store)
        }
    }
}
