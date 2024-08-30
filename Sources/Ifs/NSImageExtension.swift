import Cocoa

extension NSImage {

    func resized(to: CGSize) -> NSImage {
        let bm = Bitmap(size: to)
        let cgImg = bm.image { _ in
            self.draw(in: CGRect(origin: .zero, size: to))
        }
        return NSImage(cgImage: cgImg, size: size)
    }

    var pngData: Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("no cg image")
            return nil
        }
        return cgImage.pngData
    }

    var jpegData: Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("no cg image")
            return nil
        }
        return cgImage.jpegData
    }
}
