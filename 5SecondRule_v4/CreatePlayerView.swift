import Foundation
import SwiftUI
import PhotosUI

struct CreatePlayerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?

    var body: some View {
        Form {
            Section {
                VStack {
                    if let imageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    PhotosPicker("Select Photo", selection: $selectedItem)
                }
            }

            Section("Name") {
                TextField("Player name", text: $name)
            }

            Section {
                Button("Create Player") {
                    let profile = PlayerProfile(name: name, imageData: imageData)
                    store.addProfile(profile)
                    dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .navigationTitle("New Player")
        .onChange(of: selectedItem) {
            Task {
                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}
