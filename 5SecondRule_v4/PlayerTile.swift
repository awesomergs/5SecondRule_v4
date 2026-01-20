import SwiftUI

struct PlayerTile: View {
    let profile: PlayerProfile
    let isEditing: Bool
    let isActive: Bool

    var body: some View {
        VStack(spacing: 6) {

            ZStack(alignment: .topTrailing) {
                avatar
                    .overlay(
                        Circle()
                            .stroke(isEditing ? .red : .clear, lineWidth: 2)
                    )

                if isEditing {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.red)
                        .background(Circle().fill(.white))
                        .offset(x: 6, y: -6)
                }
            }

            Text(profile.name)
                .font(.caption)
                .foregroundStyle(isEditing ? .red : .primary)
                .lineLimit(1)
        }
        .wiggle(isEditing)
    }

    private var avatar: some View {
        Group {
            if let data = profile.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .overlay {
                        Text(String(profile.name.prefix(1)))
                            .font(.title)
                            .fontWeight(.bold)
                    }
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(Circle())
    }
}
