import Foundation
class IfsStatistics {
    var x: Span = Span()
    var y: Span = Span()
    var v: Span = Span()
    let a: CGAffineTransform
    var b: BitMatrix
    init(a: CGAffineTransform, b: BitMatrix) {
        self.a = a
        self.b = b
    }
}
extension IfsStatistics {
    var center: CGPoint { return CGPoint(x: x.center, y: y.center) }
    var size: CGSize { return CGSize(width: x.value, height: y.value) }
    var ratio: Float { return b.bitRatio }
    var stat: IfsStat { return IfsStat(center: center, size: size, velocity: v) }
    var visual: IfsVisual {
        let center = self.center
        let size = self.size
        let c = IfsPoint(x: Float(center.x), y: Float(center.y))
        let s = IfsPoint(x: Float(size.width), y: Float(size.height))
        let vel = IfsSpan(min: Float(v.min), max: Float(v.max))
        return IfsVisual(c: c, s: s, v: vel)
    }
}
extension IfsStatistics: IfsPlotter {
    func plot(point: CGPoint, color: CGFloat, velocity: CGPoint) throws {
        x.update(point.x)
        y.update(point.y)
        v.update(velocity.norm)
        guard -1e9 < point.x && point.x < 1e9 &&
              -1e9 < point.y && point.y < 1e9 else {
            throw IfsError.overflow
        }
        let p = point.applying(a)
        let i = Int(p.x)
        let j = Int(p.y)
        if b.inside(x: i, y: j) {
            b[i, j] = 1
        }
    }
}
struct IfsStat {
    let center: CGPoint
    let size: CGSize
    let velocity: Span
}
