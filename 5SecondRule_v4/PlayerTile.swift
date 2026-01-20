import SwiftUI
import Foundation

struct PlayerTile: View {
    let profile: PlayerProfile

    var body: some View {
        VStack(spacing: 6) {
            if let data = profile.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 64, height: 64)
                    .overlay {
                        Text(String(profile.name.prefix(1)))
                            .font(.title)
                            .fontWeight(.bold)
                    }
            }

            Text(profile.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
