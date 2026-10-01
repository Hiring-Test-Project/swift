import XCTest
@testable import SumAmounts

final class SumAmountsTests: XCTestCase {
    private func ob(_ id: UInt64, _ amountDue: UInt64, _ priority: UInt64) -> Obligation {
        Obligation(id: id, amountDue: amountDue, priority: priority)
    }

    private func settlement(_ unapplied: UInt64, _ pairs: [(UInt64, UInt64)]) -> Settlement {
        Settlement(
            lines: pairs.map { Line(id: $0.0, applied: $0.1) },
            unapplied: unapplied
        )
    }

    private func assertSettlement(
        _ payment: UInt64,
        _ obligations: [Obligation],
        _ unapplied: UInt64,
        _ pairs: [(UInt64, UInt64)]
    ) throws {
        XCTAssertEqual(try settle(payment, obligations), settlement(unapplied, pairs))
    }

    func testEmpty() throws {
        try assertSettlement(100, [], 100, [])
    }

    func testPaysInFull() throws {
        try assertSettlement(
            500,
            [ob(1, 100, 1), ob(2, 40, 3), ob(3, 60, 2)],
            300,
            [(1, 100), (2, 40), (3, 60)]
        )
    }

    func testHigherPriorityIsPaidFirst() throws {
        try assertSettlement(
            60,
            [ob(1, 80, 1), ob(2, 50, 9), ob(3, 25, 9)],
            0,
            [(1, 0), (2, 50), (3, 10)]
        )
    }

    func testSamePriorityPaysEarlierInputFirst() throws {
        try assertSettlement(
            10,
            [ob(1, 50, 1), ob(2, 30, 1), ob(3, 20, 1)],
            0,
            [(1, 10), (2, 0), (3, 0)]
        )
    }

    func testRemainderSpillsToTheNextPriority() throws {
        try assertSettlement(
            120,
            [ob(1, 100, 1), ob(2, 40, 5), ob(3, 60, 5)],
            0,
            [(1, 20), (2, 40), (3, 60)]
        )
    }

    func testDuplicateId() {
        XCTAssertThrowsError(try settle(5, [ob(1, 10, 1), ob(1, 4, 2)])) { error in
            XCTAssertEqual(error as? SettleError, .duplicateId)
        }
    }
}
