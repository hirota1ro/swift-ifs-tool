import Foundation
struct Span {
    var min: CGFloat
    var max: CGFloat
}
extension Span {
    init() {
        min = .greatestFiniteMagnitude
        max = -.greatestFiniteMagnitude
    }
    mutating func update(_ value: CGFloat) {
        min = Swift.min(min, value)
        max = Swift.max(max, value)
    }
    var isValid: Bool { return min < max }
    var value: CGFloat { return max - min }
    var center: CGFloat { return (max + min) / 2 }
    func normalized(_ value: CGFloat) -> CGFloat { return (value - min) / (max - min) }
}
