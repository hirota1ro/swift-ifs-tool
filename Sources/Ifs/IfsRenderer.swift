import Foundation
import Cocoa
protocol IfsColorResolver {
    func resolve(color: CGFloat, velocity: CGPoint) -> NSColor
}
struct IfsRenderer {
    let screen: CGAffineTransform
    let resolver: IfsColorResolver
}
extension IfsRenderer: IfsPlotter {
    func plot(point: CGPoint, color: CGFloat, velocity: CGPoint) throws {
        resolver.resolve(color: color, velocity: velocity).setFill()
        let p = point.applying(screen)
        CGRect(origin: p, size: .one).fill()
    }
}
extension CGSize {
    static let one: CGSize = CGSize(width:1, height:1)
}
struct VelocityColorResolver {
    let v: Span
}
extension VelocityColorResolver: IfsColorResolver {
    func resolve(color: CGFloat, velocity: CGPoint) -> NSColor {
        let sat = curve(v.normalized(velocity.norm))
        return NSColor(hue: color, saturation: sat, brightness: 1, alpha: 1)
    }

    func curve(_ x: CGFloat) -> CGFloat {
        return x * (2 - x) // ease out quad
    }
}
