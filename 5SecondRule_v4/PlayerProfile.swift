import Foundation
import SwiftUI

struct PlayerProfile: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var imageData: Data?   // optional profile photo

    init(id: UUID = UUID(), name: String, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.imageData = imageData
    }
}
