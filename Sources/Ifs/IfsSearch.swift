import Cocoa

extension Ifs.Search {

    mutating func run() throws {
        let found = doSearch()
        doSave(found: found)
    }

    func doSearch() -> [IfsNode] {
        let imPro = MeasurementProgress(IndeterminableProgress())
        let ctPro = MeasurementProgress(DeterminableProgress())
        ctPro.begin()
        defer { ctPro.end() }
        var threshold = self.threshold
        var failed: Int = 0
        var found: [IfsNode] = []
        while found.count < count {
            let w: [IfsAffine] = (0 ..< length).map { _ in IfsAffine.random() }
            let node = IfsNode(w: w, p: nil, z: nil, v: nil)
            let algorithm = node.algorithm
            let bm = BitMatrix(width: 128, height: 128)
            let bmAffine = CGAffineTransform.identity
              .translatedBy(x: 64, y: 64)
              .scaledBy(x: 64, y: 64)
            let statistics = IfsStatistics(a: bmAffine, b: bm)
            try? algorithm.process(iterations: iterations, plotter: statistics, progress: imPro)
            let ratio = statistics.ratio
            let r = String(format: "%.2f", ratio)
            if ratio > threshold {
                print("good: \(r) > \(threshold)", terminator:"")
                found.append(IfsNode(w: node.w, p: node.p, z: node.z, v: statistics.visual))
                ctPro.progress(Float(found.count)/Float(count))
                failed = 0
            } else {
                print("bad: \(r) < \(threshold)", terminator:"")
                failed += 1
                if failed > concession {
                    failed = 0
                    let old = threshold
                    threshold *= rate
                    print("conceded: threshold \(old) => \(threshold)", terminator:"")
                }
                print("")
            }
        }
        return found
    }

    func doSave(found: [IfsNode]) {
        let json = found.map { $0.json }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [ .prettyPrinted, .sortedKeys ])
            if let file = outputFile {
                try data.write(to: URL(fileURLWithPath: file), options: .atomic)
                print("succeeded to write \(file)")
            } else {
                if let text = String(data: data, encoding: .utf8) {
                    print(text)
                } else {
                    print("error: utf8")
                }
            }
        } catch {
            print("\(error)")
        }
    }
}
