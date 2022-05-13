import Foundation

struct IfsProbability {
    let table: [Int]

    init(vector: [Float]) {
        table = IfsProbability.build(with: vector)
    }

    init(count: Int) {
        table = IfsProbability.build(by: count)
    }
}

extension IfsProbability {

    static func build(with vector: [Float]) -> [Int] {
        let total: Float = vector.reduce(0, +)
        let normalized: [Float] = vector.map { $0 / total }
        let percent: [Int] = normalized.map { Int($0 * 100) }
        let fragments = percent.enumerated().map { Array<Int>(repeating: $0.0, count: $0.1) }
        return fragments.flatMap { $0 }
    }

    static func build(by count: Int) -> [Int] {
        let c = 100 / count
        let fragments = (0 ..< count).map { Array<Int>(repeating: $0, count: c) }
        return fragments.flatMap { $0 }
    }

    func random() -> Int {
        let i = Int.random(in: 0 ..< table.count)
        return table[i]
    }
}
