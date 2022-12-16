import Cocoa

extension Ifs.Image {
    var sizeOfImage: CGSize { return CGSize(width: width, height: height ?? width) }
    mutating func run() throws {
        guard let file = try IfsFile.read(from: inputFile) else {
            print("no file")
            return
        }
        if let node = file.singular {
            try doImage(sequence: nil, node: node)
        } else {
            for (i, node) in file.nodes.enumerated() {
                try doImage(sequence: i, node: node)
            }
        }
    }
    func doImage(sequence: Int?, node: IfsNode) throws {
        let algorithm = node.algorithm
        let stat: IfsStat
        if let vis = node.v {
            stat = vis.stat
        } else {
            stat = try createStat(algorithm: algorithm)
        }

        let imgSize = sizeOfImage
        let workSize = imgSize * CGFloat(density)
        let imgScale = min(workSize.width / stat.size.width, workSize.height / stat.size.height) * 0.9
        let affine: CGAffineTransform = .identity
          .translatedBy(x: workSize.width / 2, y: workSize.height / 2)
          .scaledBy(x: imgScale, y: imgScale)
          .translatedBy(x: -stat.center.x, y: -stat.center.y)
        let n = iterations * density * density
        let workImage = NSImage(size: workSize)
        workImage.lockFocus()
        if !transparent {
            if dark {
                NSColor.black.setFill()
            } else {
                NSColor.white.setFill()
            }
            CGRect(origin:.zero, size: workSize).fill()
        }
        let pro = MeasurementProgress(IndeterminableProgress())
        let br: IfsBrightnessResolver = dark ? BlackBackBrightnessResolver() : WhiteBackBrightnessResolver()
        let resolver = VelocityColorResolver(v: stat.velocity, easing: EaseOutQuart, brightness: br)
        try algorithm.process(iterations: n, plotter: IfsRenderer(screen: affine, resolver: resolver), progress: pro)
        workImage.unlockFocus()
        let fileURL:URL
        if let seq = sequence {
            fileURL = outputFileURL(sequence: seq)
        } else {
            fileURL = URL(fileURLWithPath: outputFile)
        }
        let image = density > 1 ? workImage.resized(to: imgSize) : workImage
        if let data = image.pngData {
            do {
                try data.write(to: fileURL, options: .atomic)
                print("succeeded to write \(fileURL.path)")
            } catch {
                print("failed to write \(error)")
            }
        }
    }
    func createStat(algorithm: IfsAlgorithm) throws -> IfsStat {
        let bm = BitMatrix(width: 128, height: 128)
        let bmAffine = CGAffineTransform.identity
          .translatedBy(x: 64, y: 64)
          .scaledBy(x: 64, y: 64)
        let statistics = IfsStatistics(a: bmAffine, b: bm)
        try algorithm.process(iterations: 1000, plotter: statistics, progress: EmptyProgress())
        return statistics.stat
    }
    func outputFileURL(sequence: Int) -> URL {
        let userFileURL = URL(fileURLWithPath: outputFile)
        let userExt:String = userFileURL.pathExtension
        let userBaseName:String = userFileURL.deletingPathExtension().lastPathComponent
        let name = "\(userBaseName)-\(sequence).\(userExt)"
        let userDirURL = userFileURL.deletingLastPathComponent()
        return userDirURL.appendingPathComponent(name)
    }
}
