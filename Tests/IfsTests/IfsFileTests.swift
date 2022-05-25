import XCTest
@testable import Ifs

class IfsFileTests: XCTestCase {

    func testIfsFloat() throws {
        let f123 = try Float.read(fromJSON: "123")!
        XCTAssertEqual(f123, 123, accuracy: 1e-5)
        let f456 = try Float.read(fromJSON: Int(456))!
        XCTAssertEqual(f456, 456, accuracy: 1e-5)
    }

    func testIfsParam() throws {
        let dict:[String: Any] = ["x": 123, "y": 456]
        let param = IfsParam(dict: dict)
        XCTAssertEqual(try param.flt("x"), 123, accuracy: 1e-5)
        XCTAssertEqual(try param.flt("y"), 456, accuracy: 1e-5)
    }

    func testIfsSpan() throws {
        let dict:[String: Any] = ["min": 123, "max": 456]
        let span = try IfsSpan.read(fromDict: dict)
        XCTAssertEqual(span.min, 123, accuracy: 1e-5)
        XCTAssertEqual(span.max, 456, accuracy: 1e-5)
    }

    func testIfsPoint() throws {
        let dict:[String: Any] = ["x": 123, "y": 456]
        let point = try IfsPoint.read(fromDict: dict)
        XCTAssertEqual(point.x, 123, accuracy: 1e-5)
        XCTAssertEqual(point.y, 456, accuracy: 1e-5)
    }

    func testIfsVisual() throws {
        let dict:[String: Any] = ["c": ["x": 100, "y": 200], "s": ["x": 300, "y": 400], "v": ["min": 123, "max": 456]]
        let visual = try IfsVisual.read(fromDict: dict)
        XCTAssertEqual(visual.c.x, 100, accuracy: 1e-5)
        XCTAssertEqual(visual.c.y, 200, accuracy: 1e-5)
        XCTAssertEqual(visual.s.x, 300, accuracy: 1e-5)
        XCTAssertEqual(visual.s.y, 400, accuracy: 1e-5)
        XCTAssertEqual(visual.v.min, 123, accuracy: 1e-5)
        XCTAssertEqual(visual.v.max, 456, accuracy: 1e-5)
    }

    func testIfsAffine() throws {
        let dict: [String: Any] = ["a":-0.2960, "b":-0.0469, "c":0.0469, "d":-0.2960, "tx": 0.3791, "ty":0.5687]
        let affine = try IfsAffine.read(fromDict: dict)
        XCTAssertEqual(affine.a, -0.2960, accuracy: 1e-5)
        XCTAssertEqual(affine.b, -0.0469, accuracy: 1e-5)
        XCTAssertEqual(affine.c, 0.0469, accuracy: 1e-5)
        XCTAssertEqual(affine.d, -0.2960, accuracy: 1e-5)
        XCTAssertEqual(affine.tx, 0.3791, accuracy: 1e-5)
        XCTAssertEqual(affine.ty, 0.5687, accuracy: 1e-5)
    }

    func testIfsNode() throws {
        let a1: [String: Any] = ["a":11, "b":12, "c":13, "d":14, "tx":15, "ty":16]
        let a2: [String: Any] = ["a":21, "b":22, "c":23, "d":24, "tx":25, "ty":26]
        let dict: [String: Any] = ["w": [a1, a2]]
        let node = try IfsNode.read(fromDict: dict)
        XCTAssertEqual(node.w.count, 2)
        XCTAssertEqual(node.w[0].a, 11)
    }

    func testIfsFile() throws {
        let a1: [String: Any] = ["a":11, "b":12, "c":13, "d":14, "tx":15, "ty":16]
        let dict: [String: Any] = ["w": [a1]]
        let file = try IfsFile.read(fromJSON: dict)!
        XCTAssertEqual(file.nodes.count, 1)
    }
}
