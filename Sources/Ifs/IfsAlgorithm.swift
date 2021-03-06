import Foundation

protocol IfsPlotter {
    func plot(point: CGPoint, color: CGFloat, velocity: CGPoint) throws
}

protocol IfsProgress {
    func begin()
    func progress(_ value: Float)
    func end()
}

struct IfsAlgorithm {
    let w: [CGAffineTransform]
    let probability: IfsProbability
    let start: CGPoint
}

extension IfsAlgorithm {

    var count: Int { return w.count }
    var deltaColor: CGFloat { return w.count > 1 ? 1 / CGFloat(w.count - 1) : 0 }

    func process(iterations: Int, plotter: IfsPlotter, progress: IfsProgress) throws {
        var p = start
        var c: CGFloat = 0
        let d = deltaColor
        var t: Int = 0
        progress.begin()
        defer { progress.end() }
        for k in 0 ..< iterations {
            //let i = Int.random(in: 0 ..< w.count)
            let i = probability.random()
            let prev = p
            p = p.applying(w[i])
            if !p.isValid { throw IfsError.math }
            c = (c + (CGFloat(i) * d)) / 2
            if k > 10 {
                try plotter.plot(point: p, color: c, velocity: p - prev)
            }
            if k > t {
                progress.progress(Float(k)/Float(iterations))
                t += iterations / 10
            }
        }
    }
}
