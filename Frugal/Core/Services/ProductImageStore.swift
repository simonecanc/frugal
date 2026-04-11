import UIKit
import SwiftUI
import Combine

/// Represents a saved product with its cutout image.
struct SavedProductItem: Identifiable, Codable {
    let id: UUID
    let imageName: String      // Filename on disk
    let productName: String
    let price: String
    let savedDate: Date

    /// A random rotation for the collage layout, generated once and persisted.
    let rotation: Double
    /// Random scale factor for visual variety
    let scale: Double
}

/// Persists cutout product images to disk and manages the list of saved items.
final class ProductImageStore: ObservableObject {
    static let shared = ProductImageStore()

    @Published var savedItems: [SavedProductItem] = []

    private let fileManager = FileManager.default
    private let metadataFileName = "saved_products.json"

    private var storeDirectory: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dir = docs.appendingPathComponent("ProductCutouts", isDirectory: true)
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    private var metadataURL: URL {
        storeDirectory.appendingPathComponent(metadataFileName)
    }

    private init() {
        loadMetadata()
    }

    // MARK: – Public API

    /// Saves a cutout image and adds it to the list.
    @MainActor
    func saveProduct(cutoutImage: UIImage, productName: String, price: String) {
        let id = UUID()
        let imageName = "\(id.uuidString).png"
        let imageURL = storeDirectory.appendingPathComponent(imageName)

        // Write PNG (preserves transparency)
        if let pngData = cutoutImage.pngData() {
            try? pngData.write(to: imageURL, options: .atomic)
        }

        let item = SavedProductItem(
            id: id,
            imageName: imageName,
            productName: productName,
            price: price,
            savedDate: Date(),
            rotation: Double.random(in: -6...6),
            scale: Double.random(in: 0.92...1.0)
        )

        savedItems.insert(item, at: 0)
        persistMetadata()
    }

    /// Loads the UIImage for a given saved product.
    func loadImage(for item: SavedProductItem) -> UIImage? {
        let url = storeDirectory.appendingPathComponent(item.imageName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    /// Removes a saved item and its image file.
    @MainActor
    func removeProduct(_ item: SavedProductItem) {
        let url = storeDirectory.appendingPathComponent(item.imageName)
        try? fileManager.removeItem(at: url)
        savedItems.removeAll { $0.id == item.id }
        persistMetadata()
    }

    // MARK: – Persistence

    private func loadMetadata() {
        guard fileManager.fileExists(atPath: metadataURL.path),
              let data = try? Data(contentsOf: metadataURL),
              let items = try? JSONDecoder().decode([SavedProductItem].self, from: data) else {
            return
        }
        savedItems = items
    }

    private func persistMetadata() {
        guard let data = try? JSONEncoder().encode(savedItems) else { return }
        try? data.write(to: metadataURL, options: .atomic)
    }
}
