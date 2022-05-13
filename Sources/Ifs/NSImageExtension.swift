import Cocoa
extension NSImage {
    func resized(to: CGSize) -> NSImage {
        let image = NSImage(size: to)
        image.lockFocus()
        self.draw(in: CGRect(origin: .zero, size: to))
        image.unlockFocus()
        return image
    }
    var pngData: Data? {
        guard let tiffRepresentation = self.tiffRepresentation else {
            print("no tiffRep")
            return nil
        }
        guard let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            print("no bitmapImageRep")
            return nil
        }
        guard let data = bitmapImage.representation(using: .png, properties: [:]) else {
            print("no data")
            return nil
        }
        return data
    }
    var jpegData: Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("no cg image")
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        guard let data = bitmapRep.representation(using: .jpeg, properties: [:]) else {
            print("no data")
            return nil
        }
        return data
    }
}
