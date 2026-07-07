import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productId = "com.shimondeitel.volunteerhrs.pro"

    @Published var isPro: Bool = false
    @Published var products: [Product] = []
    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self?.handle(transaction)
                }
            }
        }
        Task { await load() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func load() async {
        if let products = try? await Product.products(for: [Self.productId]) {
            self.products = products
        }
        await refreshEntitlements()
    }

    func purchase() async {
        guard let product = products.first else { return }
        guard let result = try? await product.purchase() else { return }
        switch result {
        case .success(let verification):
            if case .verified(let transaction) = verification {
                await handle(transaction)
            }
        default:
            break
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func handle(_ transaction: Transaction) async {
        await transaction.finish()
        await refreshEntitlements()
    }

    private func refreshEntitlements() async {
        var pro = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let t) = result, t.productID == Self.productId {
                pro = true
            }
        }
        isPro = pro
    }
}
