import XCTest
@testable import Ifs

class CoreGraphicsExtensionTests: XCTestCase {

    func testCoreGraphicsExtensionFloat() throws {
        XCTAssertEqual(CGFloat(90).radians, .pi/2, accuracy: 1e-5)
        XCTAssertEqual((CGFloat.pi/2).degrees, 90, accuracy: 1e-5)
        XCTAssertEqual(CGFloat(-2).sign, -1, accuracy: 1e-5)
    }

    func testCoreGraphicsExtensionPoint() throws {
        XCTAssertEqual(CGPoint(x: 1, y: 1), CGPoint(x: 1, y: 0) + CGPoint(x: 0, y: 1))
    }

    func testCoreGraphicsExtensionAffine() throws {
        let rot90 = CGAffineTransform(rotationAngle: .pi/2)
        let p = CGPoint(x: 1, y: 0).applying(rot90)
        XCTAssertEqual(p.x, 0, accuracy: 1e-5)
        XCTAssertEqual(p.y, 1, accuracy: 1e-5)
    }
}
