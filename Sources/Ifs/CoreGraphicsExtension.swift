import CoreGraphics
extension CGFloat {
    var radians: CGFloat { return self / 180 * .pi }
    var degrees: CGFloat { return self * 180 / .pi }
    var sign: CGFloat { return self < 0 ? -1 : self > 0 ? 1 : 0 }
}
extension CGPoint {
    static func + (a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(x: a.x + b.x, y: a.y + b.y) }
    static func - (a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(x: a.x - b.x, y: a.y - b.y) }
    static func * (v: CGPoint, s: CGFloat) -> CGPoint { return CGPoint(x: v.x * s, y: v.y * s) }
    static func * (s: CGFloat, v: CGPoint) -> CGPoint { return CGPoint(x: s * v.x, y: s * v.y) }
    static func * (a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(x: a.x * b.x, y: a.y * b.y) }
    static func / (v: CGPoint, s: CGFloat) -> CGPoint { return CGPoint(x: v.x / s, y: v.y / s) }
    static func / (s: CGFloat, v: CGPoint) -> CGPoint { return CGPoint(x: s / v.x, y: s / v.y) }
    static func / (a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(x: a.x / b.x, y: a.y / b.y) }
    static prefix func - (p: CGPoint) -> CGPoint { return CGPoint(x: -p.x, y: -p.y) }
    var quadrance: CGFloat { return x * x + y * y }
    var norm: CGFloat { return hypot(x, y) }
    var normalized: CGPoint { return self / norm }
    func rotateBy(angle: CGFloat) -> CGPoint {
        return applying(CGAffineTransform(rotationAngle: angle))
    }
    func dot(_ p: CGPoint) -> CGFloat { return x * p.x + y * p.y }
    func cross(_ p: CGPoint) -> CGFloat { return x * p.y - y * p.x }
    func distance(to p: CGPoint) -> CGFloat { (p - self).norm }
    var heading: CGFloat { return atan2(y, x) }
    func angle(to: CGPoint) -> CGFloat { return CGPoint.angle(from: self, to: to) }
    static func angle(from u: CGPoint, to v: CGPoint) -> CGFloat {
        return (u.cross(v)).sign * acos(u.dot(v) / (u.norm * v.norm))
    }
    init(fromAngle t: CGFloat) { self.init(x: cos(t), y: sin(t)) }
    var isInvalid: Bool { return x.isNaN || y.isNaN }
    var isValid: Bool { return !isInvalid }
}
extension CGFloat {
    var f2: String { return String(format: "%.2f", self) }
}
extension CGPoint: CustomStringConvertible {
    public var description: String {
        return "(\(x.f2), \(y.f2))"
    }
}
extension CGAffineTransform: CustomStringConvertible {
    public var description: String {
        return "a:\(a.f2), b:\(b.f2), c:\(c.f2), d:\(d.f2), tx:\(tx.f2), ty:\(ty.f2)"
    }
}
extension CGSize {
    static func + (a: CGSize, b: CGSize) -> CGSize { return CGSize(width: a.width + b.width, height: a.height + b.height) }
    static func - (a: CGSize, b: CGSize) -> CGSize { return CGSize(width: a.width - b.width, height: a.height - b.height) }
    static func * (v: CGSize, s: CGFloat) -> CGSize { return CGSize(width: v.width * s, height: v.height * s) }
    static func * (s: CGFloat, v: CGSize) -> CGSize { return CGSize(width: s * v.width, height: s * v.height) }
    static func * (a: CGSize, b: CGSize) -> CGSize { return CGSize(width: a.width * b.width, height: a.height * b.height) }
    static func / (v: CGSize, s: CGFloat) -> CGSize { return CGSize(width: v.width / s, height: v.height / s) }
    static func / (s: CGFloat, v: CGSize) -> CGSize { return CGSize(width: s / v.width, height: s / v.height) }
    static func / (a: CGSize, b: CGSize) -> CGSize { return CGSize(width: a.width / b.width, height: a.height / b.height) }
}
