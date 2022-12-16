import CoreImage
import CoreGraphics
import Cocoa

extension CIImage {

    func gammaAdjusted(inputPower: Float) -> CIImage? {
        guard let filter = CIFilter(name: "CIGammaAdjust") else {
            print("no gamma filter")
            return nil
        }
        filter.setValue(self, forKey: kCIInputImageKey)
        filter.setValue(inputPower, forKey: "inputPower")
        return filter.outputImage
    }
}

extension CGImage {

    func gammaAdjusted(inputPower: Float) -> CGImage? {
        let srcImg = CIImage(cgImage: self)
        guard let dstImg = srcImg.gammaAdjusted(inputPower: inputPower) else {
            print("no dst image")
            return nil
        }
        let ctx = CIContext(options: nil)
        return ctx.createCGImage(dstImg, from: dstImg.extent)
    }
}

extension NSImage {

    func gammaAdjusted(inputPower: Float) -> NSImage? {
        guard let srcImage = cgImage else {
            print("no src image")
            return nil
        }
        guard let dstImg = srcImage.gammaAdjusted(inputPower: inputPower) else {
            print("no dst image")
            return nil
        }
        return NSImage(cgImage: dstImg, size: size)
    }

    var cgImage: CGImage? {
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
