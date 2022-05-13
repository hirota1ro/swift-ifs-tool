import Foundation
struct BitArray {
    let size: Int
    var array: [UInt64]
    init(size: Int) {
        self.size = size
        self.array = Array<UInt64>(repeating: 0, count: Int(ceil(Float(size) / 64)))
    }
    subscript(_ i: Int) -> Int {
        get {
            let j: Int = i % 64
            let k: Int = i / 64
            return Int((array[k] >> j) & 1)
        }
        set {
            let j: Int = i % 64
            let k: Int = i / 64
            var v = array[k]
            let b: UInt64 = 1 << j
            if newValue != 0 {
                v |= b
            } else {
                v &= ~b
            }
            array[k] = v
        }
    }
    var bitCount: Int {
        return array.reduce(0, { $0 + $1.bitCount })
    }
}
fileprivate let bitCountTable: [Int] = [ 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 ]
extension UInt64 {
    var bitCount: Int {
        var sum: Int = 0
        for i in 0 ..< 16 {
            let b = 4 * UInt64(i)
            let j = self >> b
            let k = j & 15
            sum += bitCountTable[Int(k)]
        }
        return sum
    }
}
struct BitMatrix {
    let width: Int
    let height: Int
    var array: BitArray
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        array = BitArray(size: width * height)
    }
    subscript(_ x: Int, _ y: Int) -> Int {
        get { return array[y * width + x] }
        set { array[y * width + x] = newValue }
    }
    func inside(x: Int, y: Int) -> Bool {
        return 0 <= x && x < width && 0 <= y && y < height
    }
    var bitRatio: Float { return Float(array.bitCount) / Float(width * height) }
}
