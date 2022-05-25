import XCTest
@testable import Ifs

class IfsProbabilityTests: XCTestCase {

    func testIfsProbability() throws {
        let pb = IfsProbability(vector: [4, 3, 2, 1])
        let ct0 = pb.table.map({ $0 == 0 ? 1 : 0 }).reduce(0, +)
        let ct1 = pb.table.map({ $0 == 1 ? 1 : 0 }).reduce(0, +)
        let ct2 = pb.table.map({ $0 == 2 ? 1 : 0 }).reduce(0, +)
        let ct3 = pb.table.map({ $0 == 3 ? 1 : 0 }).reduce(0, +)
        XCTAssertEqual(ct0, 40)
        XCTAssertEqual(ct1, 30)
        XCTAssertEqual(ct2, 20)
        XCTAssertEqual(ct3, 10)
    }
}
