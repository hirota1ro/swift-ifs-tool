import XCTest
@testable import Ifs

final class IfsAlgorithmTests: XCTestCase {

    func testAlgorithmFig2c() throws {
        let w1 = CGAffineTransform(a: 0.6416, b:-0.3591, c: 0.3591, d: 0.6416, tx: 0.1480, ty: 0.3403)
        let w2 = CGAffineTransform(a: 0.1906, b: 0.2554, c:-0.2554, d: 0.1906, tx: 0.4162, ty: 0.6122)
        let w3 = CGAffineTransform(a: 0.1681, b: 0.2279, c:-0.2279, d: 0.1681, tx: 0.4531, ty:-0.0205)
        let w4 = CGAffineTransform(a:-0.2848, b: 0.0141, c:-0.0141, d:-0.2848, tx: 0.3362, ty: 0.8164)
        let w5 = CGAffineTransform(a: 0.3672, b:-0.0051, c: 0.0051, d: 0.3672, tx: 0.0776, ty: 0.1726)
        let w = [w1, w2, w3, w4, w5]
        let algorithm = IfsAlgorithm(w: w, probability: IfsProbability(count: 5), start: CGPoint(x:0.01, y:0.01))
        try algorithm.process(iterations: 3, plotter: EmptyPlotter(), progress: EmptyProgress())
    }

    func testAlgorithmFig3b() throws {
        let w1 = CGAffineTransform(a: 0.7155, b: 0.4589, c:-0.4589, d: 0.7155, tx: 0.3412, ty:-0.0939)
        let w2 = CGAffineTransform(a: 0.2362, b: 0.1849, c:-0.1849, d: 0.2362, tx: 0.2160, ty: 0.0852)
        let w3 = CGAffineTransform(a: 0.2819, b: 0.1025, c: 0.1849, d:-0.3205, tx: 0.5670, ty: 0.3792)
        let w4 = CGAffineTransform(a: 0.1080, b:-0.2799, c: 0.2799, d: 0.3303, tx: 0.3303, ty: 0.9098)
        let w = [w1, w2, w3, w4]
        let algorithm = IfsAlgorithm(w: w, probability: IfsProbability(count: 4), start: CGPoint(x:0.01, y:0.01))
        try algorithm.process(iterations: 3, plotter: EmptyPlotter(), progress: EmptyProgress())
    }

    func testAlgorithmFig4a() throws {
        let w1 = CGAffineTransform(a:-0.2960, b:-0.0469, c:0.0469, d:-0.2960, tx: 0.3791, ty:0.5687)
        let w2 = CGAffineTransform(a: 0.8302, b:-0.4091, c:0.4091, d: 0.8302, tx:-0.0674, ty:0.3319)
        let w = [w1, w2]
        let algorithm = IfsAlgorithm(w: w, probability: IfsProbability(count: 2), start: CGPoint(x:0.01, y:0.01))
        try algorithm.process(iterations: 3, plotter: EmptyPlotter(), progress: EmptyProgress())
    }
}

struct EmptyPlotter: IfsPlotter {
    func plot(point: CGPoint, color: CGFloat, velocity: CGPoint) {
    }
}
