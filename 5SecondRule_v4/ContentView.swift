import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var store = AppStore()

    var body: some View {
        NavigationStack {
            HomeView()
                .environmentObject(store)
        }
    }
}
#Preview {
    ContentView()
}