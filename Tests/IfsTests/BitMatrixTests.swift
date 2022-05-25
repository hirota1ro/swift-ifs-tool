import XCTest
@testable import Ifs

class BitMatrixTests: XCTestCase {

    func testBitArray() throws {
        var ba = BitArray(size: 10)
        ba[3] = 1
        XCTAssertEqual(ba[3], 1)
        XCTAssertEqual(ba.bitCount, 1)
        ba[3] = 0
        XCTAssertEqual(ba[2], 0)
        XCTAssertEqual(ba.bitCount, 0)
    }

    func testBitMatrix() throws {
        var bm = BitMatrix(width: 10, height: 10)
        bm[3, 5] = 1
        XCTAssertEqual(bm[3, 5], 1)
        XCTAssertEqual(bm.bitRatio, 0.01, accuracy: 1e-5)
        bm[3, 5] = 0
        XCTAssertEqual(bm[2, 5], 0)
        XCTAssertEqual(bm.bitRatio, 0, accuracy: 1e-5)
    }
}
