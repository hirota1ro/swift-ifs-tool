import XCTest
@testable import Ifs

class IfsStatisticsTests: XCTestCase {

    func testIfsStatistics() throws {
        let w1 = CGAffineTransform(a:-0.2960, b:-0.0469, c:0.0469, d:-0.2960, tx: 0.3791, ty:0.5687)
        let w2 = CGAffineTransform(a: 0.8302, b:-0.4091, c:0.4091, d: 0.8302, tx:-0.0674, ty:0.3319)
        let w = [w1, w2]
        let algorithm = IfsAlgorithm(w: w, probability: IfsProbability(count: 2), start: CGPoint(x:0.01, y:0.01))

        let bm = BitMatrix(width: 200, height: 200)
        let affine = CGAffineTransform.identity
          .translatedBy(x: 100, y: 100)
          .scaledBy(x: 100, y: 100)
        let st = IfsStatistics(a: affine, b: bm)
        try algorithm.process(iterations: 100, plotter: st, progress: EmptyProgress())
        let stat = st.stat
        XCTAssertEqual(0.49, stat.center.x, accuracy: 0.2)
        XCTAssertEqual(0.51, stat.center.y, accuracy: 0.2)
        XCTAssertEqual(0.5, stat.size.width, accuracy: 0.8)
        XCTAssertEqual(0.35, stat.size.height, accuracy: 0.2)
        XCTAssertEqual(0.00, stat.velocity.min, accuracy: 0.2)
        XCTAssertEqual(0.68, stat.velocity.max, accuracy: 0.2)
    }
}
