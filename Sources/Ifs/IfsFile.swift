import Foundation

struct IfsFile {
    let nodes: [IfsNode]
}

extension IfsFile {
    static func read(from filePath: String) throws -> IfsFile? {
        let fileURL = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileURL)
        let json = try JSONSerialization.jsonObject(with: data)
        return try read(fromJSON: json)
    }
    static func read(fromJSON: Any?) throws -> IfsFile? {
        guard let val = fromJSON else { return nil }
        if let dict = val as? [String: Any] {
            let node = try IfsNode.read(fromDict: dict)
            return IfsFile(nodes: [node])
        }
        if let array = val as? [Any] {
            return try read(fromArray: array)
        }
        throw IfsError.invalidJSON
    }
    static func read(fromArray: [Any]) throws -> IfsFile {
        let nodes = try fromArray.compactMap {
            return try IfsNode.read(fromJSON: $0)
        }
        return IfsFile(nodes: nodes)
    }
    var singular: IfsNode? {
        if nodes.count == 1 {
            return nodes.first
        }
        return nil
    }
}

struct IfsNode {
    let w: [IfsAffine]
    let p: [Float]?
    let z: IfsPoint?
    let v: IfsVisual?
}

extension IfsNode {
    static func read(fromJSON: Any?) throws -> IfsNode? {
        guard let val = fromJSON else { return nil }
        if let dict = val as? [String: Any] {
            return try read(fromDict: dict)
        }
        if let array = val as? [Any] {
            return try read(fromArray: array)
        }
        throw IfsError.invalidJSON
    }
    static func read(fromDict: [String: Any]) throws -> IfsNode {
        guard let wval = fromDict["w"] else { throw IfsError.noParam("w") }
        let w = try IfsAffine.arrayRead(fromJSON: wval)
        let p: [Float]? = try Float.arrayRead(fromJSON: fromDict["p"])
        let z: IfsPoint? = try IfsPoint.read(fromJSON: fromDict["z"])
        let v: IfsVisual? = try IfsVisual.read(fromJSON: fromDict["v"])
        return IfsNode(w: w, p: p, z: z, v: v)
    }
    static func read(fromArray: [Any]) throws -> IfsNode {
        let w = try fromArray.compactMap { try IfsAffine.read(fromJSON: $0) }
        return IfsNode(w: w, p: nil, z: nil, v: nil)
    }
    var json: [String: Any] {
        let ww = w.map { $0.json }
        var dict: [String: Any] = ["w": ww]
        if let pval = p {
            dict["p"] = pval
        }
        if let zval = z {
            dict["z"] = zval.json
        }
        if let vval = v {
            dict["v"] = vval.json
        }
        return dict
    }
    var algorithm: IfsAlgorithm {
        let aa: [CGAffineTransform] = w.map { $0.cgAffine }
        let pp: IfsProbability
        if let p = self.p {
            pp = IfsProbability(vector: p)
        } else {
            pp = IfsProbability(count: aa.count)
        }
        let zz = z?.cgPoint ?? CGPoint(x: 0.01, y: 0.01)
        return IfsAlgorithm(w: aa, probability: pp, start: zz)
    }
}

enum IfsError: Error {
    case invalidJSON
    case noParam(String)
    case math
    case overflow
}

struct IfsAffine {
    let a: Float
    let b: Float
    let c: Float
    let d: Float
    let tx: Float
    let ty: Float
}

extension IfsAffine {
    static func arrayRead(fromJSON: Any) throws -> [IfsAffine] {
        if let array = fromJSON as? [Any] {
            return try arrayRead(fromArray: array)
        }
        throw IfsError.invalidJSON
    }
    static func arrayRead(fromArray: [Any]) throws -> [IfsAffine] {
        return try fromArray.map { try read(fromJSON: $0) }
    }
    static func read(fromJSON: Any) throws -> IfsAffine {
        if let dict = fromJSON as? [String: Any] {
            return try read(fromDict: dict)
        }
        throw IfsError.invalidJSON
    }
    static func read(fromDict: [String: Any]) throws -> IfsAffine {
        let param = IfsParam(dict: fromDict)
        return IfsAffine(a: try param.flt("a"), b: try param.flt("b"),
                         c: try param.flt("c"), d: try param.flt("d"),
                         tx: try param.flt("tx"), ty: try param.flt("ty"))
    }
    var json: [String: Any] {
        return ["a": a, "b": b, "c": c, "d": d, "tx": tx, "ty": ty]
    }
    var csv: [String] {
        return ["\(a)", "\(b)", "\(c)", "\(d)", "\(tx)", "\(ty)"]
    }
    var cgAffine: CGAffineTransform {
        return CGAffineTransform(a:CGFloat(a), b:CGFloat(b), c:CGFloat(c), d:CGFloat(d), tx:CGFloat(tx), ty:CGFloat(ty))
    }
    static func random0() -> IfsAffine {
        let a = Float.random(in: -1 ... 1)
        let b = Float.random(in: -1 ... 1)
        let c = Float.random(in: -1 ... 1)
        let d = Float.random(in: -1 ... 1)
        let tx = Float.random(in: -1 ... 1)
        let ty = Float.random(in: -1 ... 1)
        return IfsAffine(a:a, b:b, c:c, d:d, tx:tx, ty:ty)
    }
    static func random() -> IfsAffine {
        let angle = Float.random(in: -.pi ..< .pi)
        let tx = Float.random(in: -1 ..< 1)
        let ty = Float.random(in: -1 ..< 1)
        let scl = Float.random(in: -1 ..< 1)
        let rt = IfsAffine(rotationAngle: angle)
        let tr = IfsAffine(translationX: tx, y: ty)
        let sc = IfsAffine(scaleX: scl, y: scl)
        return rt.concat(sc).concat(tr)
    }
    func concat(_ o: IfsAffine) -> IfsAffine {
        return IfsAffine(a: a*o.a+c*o.b, b: b*o.a+d*o.b, c:a*o.c+c*o.d , d: b*o.c+d*o.d, tx:a*o.tx+c*o.ty+tx, ty:b*o.tx+d*o.ty+ty)
    }
    init(rotationAngle t: Float) {
        let s = sin(t)
        let c = cos(t)
        self.init(a: c, b: s, c: -s, d: c, tx:0, ty:0)
    }
    init(translationX tx: Float, y ty: Float) {
        self.init(a: 1, b: 0, c: 0, d: 1, tx:tx, ty:ty)
    }
    init(scaleX sx: Float, y sy: Float) {
        self.init(a: sx, b: 0, c: 0, d: sy, tx:0, ty:0)
    }
    init(skewX sx: Float, y sy: Float) {
        self.init(a: 1, b: sx, c: sy, d: 1, tx:0, ty:0)
    }
}

struct IfsVisual {
    let c: IfsPoint
    let s: IfsPoint
    let v: IfsSpan
}

extension IfsVisual {
    static func read(fromJSON: Any?) throws -> IfsVisual? {
        guard let val = fromJSON else { return nil }
        if let dict = val as? [String: Any] {
            return try read(fromDict: dict)
        }
        throw IfsError.invalidJSON
    }
    static func read(fromDict: [String: Any]) throws -> IfsVisual {
        guard let c = fromDict["c"] else { throw IfsError.noParam("c") }
        guard let s = fromDict["s"] else { throw IfsError.noParam("s") }
        guard let v = fromDict["v"] else { throw IfsError.noParam("v") }
        guard let cc = try IfsPoint.read(fromJSON: c) else { throw IfsError.invalidJSON }
        guard let ss = try IfsPoint.read(fromJSON: s) else { throw IfsError.invalidJSON }
        guard let vv = try IfsSpan.read(fromJSON: v) else { throw IfsError.invalidJSON }
        return IfsVisual(c: cc, s: ss, v: vv)
    }
    var json: [String: Any] { return ["c": c.json, "s": s.json, "v": v.json] }
    var csv: [String] { return c.csv + s.csv + v.csv }
    var stat: IfsStat {
        return IfsStat(center: c.cgPoint, size: s.cgSize, velocity: v.span)
    }
}

struct IfsPoint {
    let x: Float
    let y: Float
}

extension IfsPoint {
    static func read(fromJSON: Any?) throws -> IfsPoint? {
        guard let val = fromJSON else { return nil }
        if let dict = val as? [String: Any] {
            return try read(fromDict: dict)
        }
        throw IfsError.invalidJSON
    }
    static func read(fromDict: [String: Any]) throws -> IfsPoint {
        let param = IfsParam(dict: fromDict)
        return IfsPoint(x: try param.flt("x"), y: try param.flt("y"))
    }
    var json: [String: Any] { return ["x": x, "y": y] }
    var csv: [String] { return ["\(x)", "\(y)"] }
    var cgPoint: CGPoint { return CGPoint(x:CGFloat(x), y:CGFloat(y)) }
    var cgSize: CGSize { return CGSize(width:CGFloat(x), height:CGFloat(y)) }
}

struct IfsSpan {
    let min: Float
    let max: Float
}

extension IfsSpan {
    static func read(fromJSON: Any?) throws -> IfsSpan? {
        guard let val = fromJSON else { return nil }
        if let dict = val as? [String: Any] {
            return try read(fromDict: dict)
        }
        throw IfsError.invalidJSON
    }
    static func read(fromDict: [String: Any]) throws -> IfsSpan {
        let param = IfsParam(dict: fromDict)
        return IfsSpan(min: try param.flt("min"), max: try param.flt("max"))
    }
    var json: [String: Any] { return ["min": min, "max": max] }
    var csv: [String] { return ["\(min)", "\(max)"] }
    var span: Span { return Span(min:CGFloat(min), max:CGFloat(max)) }
}

struct IfsParam {
    let dict: [String: Any]
}

extension IfsParam {
    func flt(_ key: String) throws -> Float {
        if let fval = try Float.read(fromJSON: dict[key]) {
            return fval
        }
        throw IfsError.noParam(key)
    }
}

extension Float {
    static func arrayRead(fromJSON: Any?) throws -> [Float]? {
        if let ary = fromJSON as? [Any] {
            return try arrayRead(fromArray: ary)
        }
        return nil
    }
    static func arrayRead(fromArray: [Any]) throws -> [Float] {
        return try fromArray.compactMap { try Float.read(fromJSON: $0) }
    }

    static func read(fromJSON: Any?) throws -> Float? {
        guard let value = fromJSON else { return nil }
        if let f = value as? Float {
            return f
        }
        if let d = value as? NSDecimalNumber {
            return d.floatValue
        }
        if let _ = value as? [Any] { throw IfsError.invalidJSON }
        if let _ = value as? [String: Any] { throw IfsError.invalidJSON }
        return Float("\(value)")
    }
}
