import XCTest
@testable import Volunteerhrs

@MainActor
final class VolunteerhrsTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoadedBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(title: "New", detail: "d", value: 1)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteByIdRemovesItem() {
        store.add(title: "ToDelete", detail: "d", value: 1)
        guard let item = store.items.first else { return XCTFail("no item") }
        store.delete(id: item.id)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testDeleteAtOffsetsRemovesItem() {
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testCanAddMoreWhenBelowLimit() {
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimit() {
        while store.items.count < Store.freeLimit {
            store.add(title: "x", detail: "y", value: 1)
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testTotalValueSumsItems() {
        store.items = []
        store.add(title: "a", detail: "", value: 2)
        store.add(title: "b", detail: "", value: 3)
        XCTAssertEqual(store.totalValue, 5, accuracy: 0.0001)
    }

    func testUpdateModifiesItem() {
        store.add(title: "orig", detail: "d", value: 1)
        guard var item = store.items.first else { return XCTFail("no item") }
        item.title = "changed"
        store.update(item)
        XCTAssertEqual(store.items.first?.title, "changed")
    }
}
