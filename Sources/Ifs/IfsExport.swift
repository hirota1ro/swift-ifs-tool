import Cocoa

extension Ifs.Export {
    mutating func run() throws {
        guard let file = try IfsFile.read(from: inputFile) else {
            print("no file")
            return
        }
        let records1 = file.nodes.enumerated().map { (seq, node) -> [String] in
            return affineRecords(seq: seq, node: node)
        }
        let array1 = records1.flatMap { $0 }
        let array2 = file.nodes.enumerated().map { (seq, node) -> String in
            return visualRecords(seq: seq, node: node)
        }
        let array = ["#,%,a,b,c,d,tx,ty"]
          + array1
          + ["#,scale,Tx,Ty,vmin,vmax"]
          + array2
        let text = array.joined(separator: "\n")
        if let data = text.data(using: .utf8),
           let file = outputFile {
            let fileURL = URL(fileURLWithPath: file)
            do {
                try data.write(to: fileURL, options: .atomic)
                print("succeeded to write \(file)")
            } catch {
                print("\(error)")
            }
        } else {
            print(text)
        }
    }
    func affineRecords(seq: Int, node: IfsNode) -> [String] {
        return node.w.enumerated().map { (i, affine) -> String in
            let array = ["\(seq)", "\(i)"] + affine.csv
            return array.joined(separator: ",")
        }
    }
    func visualRecords(seq: Int, node: IfsNode) -> String {
        if let visual = node.v {
            let center = visual.c
            let tx = -center.x
            let ty = -center.y
            let size = visual.s
            let scale = min(2/size.x, 2/size.y)
            let velocity = visual.v
            let array = ["\(seq)", "\(scale)", "\(tx)", "\(ty)"] + velocity.csv
            return array.joined(separator: ",")
        }
        return "\(seq), <no visual>"
    }
}
