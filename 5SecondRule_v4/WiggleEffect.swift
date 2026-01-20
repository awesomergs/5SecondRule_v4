import SwiftUI

struct WiggleEffect: ViewModifier {
    let isActive: Bool
    @State private var wiggle = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isActive ? (wiggle ? -2 : 2) : 0))
            .onChange(of: isActive) {
                if isActive {
                    withAnimation(
                        .easeInOut(duration: 0.12)
                            .repeatForever(autoreverses: true)
                    ) {
                        wiggle.toggle()
                    }
                } else {
                    wiggle = false
                }
            }
    }
}

extension View {
    func wiggle(_ active: Bool) -> some View {
        modifier(WiggleEffect(isActive: active))
    }
}
