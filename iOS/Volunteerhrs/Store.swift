import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [EntryItem] = []
    @Published var categoryTogglesEnabled: Bool = true

    /// Free tier allows well above the seed data count so a fresh install never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupport.appendingPathComponent("Volunteerhrs", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("items.json")
        load()
    }

    func add(title: String, detail: String, value: Double) {
        let item = EntryItem(title: title, detail: detail, date: Date(), value: value)
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: EntryItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(id: UUID) {
        items.removeAll { $0.id == id }
        save()
    }

    var totalValue: Double {
        items.reduce(0) { $0 + $1.value }
    }

    var canAddMore: Bool {
        items.count < Store.freeLimit
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([EntryItem].self, from: data) {
            items = decoded
        } else {
            items = [EntryItem(title: "Entries 1", detail: "Sample entry", date: Date().addingTimeInterval(-86400.0), value: 5.0), EntryItem(title: "Entries 2", detail: "Sample entry", date: Date().addingTimeInterval(-172800.0), value: 10.0), EntryItem(title: "Entries 3", detail: "Sample entry", date: Date().addingTimeInterval(-259200.0), value: 15.0)]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
