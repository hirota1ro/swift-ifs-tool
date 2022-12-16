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
    let easing: IfsEasing
    let brightness: IfsBrightnessResolver
}
extension VelocityColorResolver: IfsColorResolver {
    func resolve(color: CGFloat, velocity: CGPoint) -> NSColor {
        let sat = easing(v.normalized(velocity.norm)).clamped(to: 0.0 ... 1.0)
        let hue = color - floor(color)
        let bri = brightness.resolve(hue: hue, saturation: sat)
        return NSColor(hue: hue, saturation: sat, brightness: bri, alpha: 1)
    }
}

typealias IfsEasing = (CGFloat) -> CGFloat
let EaseNone = { (_ x: CGFloat) -> CGFloat in return x }
let EaseOutQuad = { (_ x: CGFloat) -> CGFloat in return x * (2 - x) }
let EaseInQuad = { (_ x: CGFloat) -> CGFloat in return x * x }
let EaseOutQuart = { (_ x: CGFloat) -> CGFloat in return 1 - pow(1 - x, 4) }

protocol IfsBrightnessResolver {
    func resolve(hue: CGFloat, saturation sat: CGFloat) -> CGFloat
}
struct WhiteBackBrightnessResolver: IfsBrightnessResolver {
    func resolve(hue: CGFloat, saturation sat: CGFloat) -> CGFloat { return sat }
}
struct BlackBackBrightnessResolver: IfsBrightnessResolver {
    func resolve(hue: CGFloat, saturation sat: CGFloat) -> CGFloat { return 1 }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
