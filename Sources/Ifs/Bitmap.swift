import Cocoa
import CoreGraphics
import Foundation

/// A utility for creating bitmap images in memory.
///
/// Example
/// ```
///     let bitmap = Bitmap(size: CGSize(width: 640, height: 480))
///     let cgImage = bitmap.image { (cgContext) in
///         cgContext.translateBy(x: 100, y: 200)
///         "Hello".draw(at: .zero)
///     }
///     let data = cgImage.pngData
///     do {
///         try data.write(to: pngURL, options: .atomic)
///         print("succeeded to write \(pngURL.path)")
///     } catch {
///         print("failed to write \(error)")
///     }
/// ```
///
struct Bitmap {
    let cgContext: CGContext
}

extension Bitmap {

    /// initializes with size
    /// - Parameter size: size of the image
    init(size: CGSize) {
        // create Bitmap context
        guard let cgContext = CGContext(data: nil,
                                        width: Int(ceil(size.width)),
                                        height: Int(ceil(size.height)),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(ceil(size.width)),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            fatalError("CGContext.init()")
        }
        self.init(cgContext: cgContext)
    }

    /// Draw on the bitmap and get the image object.
    /// - Parameter callback: Drawing Functions
    /// - Returns: core graphics image object
    func image(with callback: (CGContext) throws -> Void) rethrows -> CGImage {
        // To be able to draw NSBezierPath etc.
        let save = NSGraphicsContext.current
        NSGraphicsContext.current = NSGraphicsContext(cgContext: cgContext, flipped: false)
        defer { NSGraphicsContext.current = save }

        try callback(cgContext)

        // obtain core graphics image object
        guard let cgImage = cgContext.makeImage() else {
            fatalError("CGContext.makeImage()")
        }
        return cgImage
    }
}

// MARK: Utilities

extension CGImage {

    /// Gets the PNG bytes from an image object.
    /// - Parameter cgImage: image object
    /// - Returns: PNG byte array
    var pngData: Data {
        let bitmapRep = NSBitmapImageRep(cgImage: self)
        guard let data = bitmapRep.representation(using: .png, properties: [:]) else {
            fatalError("no data")
        }
        return data
    }

    /// Gets the JPEG bytes from an image object.
    /// - Parameter cgImage: image object
    /// - Returns: JPEG byte array
    var jpegData: Data {
        let bitmapRep = NSBitmapImageRep(cgImage: self)
        guard let data = bitmapRep.representation(using: .jpeg, properties: [:]) else {
            fatalError("no data")
        }
        return data
    }
}
