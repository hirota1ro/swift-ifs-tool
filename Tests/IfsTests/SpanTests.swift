import XCTest
@testable import Ifs

class SpanTests: XCTestCase {

    func testSpan() throws {
        let s01 = Span(min: 10, max: 20)
        XCTAssertEqual(s01.normalized(15), 0.5, accuracy: 1e-5)

        var vs = Span()
        vs.update(0.5)
        vs.update(0.1)
        vs.update(0.9)
        XCTAssertEqual(vs.min, 0.1, accuracy: 1e-5)
        XCTAssertEqual(vs.max, 0.9, accuracy: 1e-5)
    }
}
