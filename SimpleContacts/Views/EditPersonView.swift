import Foundation
import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct EditPersonView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var person: Person
    @State private var selectedItem: PhotosPickerItem?
    @State private var photoError: String?
    @FocusState private var isEditing: Bool

    var body: some View {
        Form {
            Section("Photo") {
                if let imageData = person.photo,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("Contact photo")
                        .accessibilityIdentifier("contactPhoto")
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
                .accessibilityIdentifier("selectPhoto")
            }

            Section("Information") {
                TextField("Name", text: $person.name)
                    .textContentType(.name)
                    .focused($isEditing)
                    .accessibilityIdentifier("personName")
                TextField("Email", text: $person.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($isEditing)
                    .accessibilityIdentifier("personEmail")
            }

            Section("Details") {
                TextField("Details", text: $person.details, axis: .vertical)
                    .lineLimit(3...6)
                    .focused($isEditing)
                    .accessibilityIdentifier("personDetails")
            }
        }
        .navigationTitle("Edit Person")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isEditing = false }
            }
        }
        .onChange(of: selectedItem) { _, _ in
            loadPhoto()
        }
        .alert("Unable to Load Photo", isPresented: Binding(
            get: { photoError != nil },
            set: { if !$0 { photoError = nil } }
        )) {
            Button("OK", role: .cancel) { photoError = nil }
        } message: {
            Text(photoError ?? "Please select another photo.")
        }
    }

    private func loadPhoto() {
        guard let selectedItem else { return }
        Task { @MainActor in
            do {
                if let data = try await selectedItem.loadTransferable(type: Data.self) {
                    person.photo = data
                } else {
                    photoError = "This photo could not be read. Please select another photo."
                }
            } catch {
                photoError = error.localizedDescription
            }
        }
    }
}
