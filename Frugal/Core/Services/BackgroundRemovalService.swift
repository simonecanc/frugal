import UIKit
import Vision
import CoreImage

/// Service that uses Apple Vision to remove background from product images,
/// producing a cutout with transparent background.
final class BackgroundRemovalService {
    static let shared = BackgroundRemovalService()
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    private init() {}

    /// Removes background from the given image using Vision framework.
    /// Returns a UIImage with transparent background on success.
    func removeBackground(from image: UIImage) async -> UIImage? {
        // Step 1: Normalize orientation so pixels match what we see visually.
        // Camera images often come with .right orientation — the CGImage pixels
        // are rotated vs. the displayed image. Normalising eliminates this
        // mismatch between the mask and the pixel data.
        let normalised = image.normalizedOrientation()

        guard let cgImage = normalised.cgImage else { return nil }

        if #available(iOS 17.0, *) {
            return await removeBackgroundiOS17(cgImage: cgImage)
        } else {
            return normalised
        }
    }

    // MARK: – iOS 17+ (VNGenerateForegroundInstanceMaskRequest)

    @available(iOS 17.0, *)
    private func removeBackgroundiOS17(cgImage: CGImage) async -> UIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()

        // Because we normalised the image, orientation is always .up
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up, options: [:])

        do {
            try handler.perform([request])

            guard let observation = request.results?.first else {
                print("[BackgroundRemoval] No foreground instances found")
                return nil
            }

            // The mask from generateScaledMaskForImage is already matched to
            // the input image dimensions when the handler was created with
            // the same CGImage.
            let maskBuffer = try observation.generateScaledMaskForImage(
                forInstances: observation.allInstances,
                from: handler
            )

            return applyMask(maskBuffer, to: cgImage)

        } catch {
            print("[BackgroundRemoval] Failed: \(error.localizedDescription)")
            return UIImage(cgImage: cgImage)
        }
    }

    // MARK: – Mask Application

    private func applyMask(_ mask: CVPixelBuffer, to cgImage: CGImage) -> UIImage? {
        let maskCI = CIImage(cvPixelBuffer: mask)
        let originalCI = CIImage(cgImage: cgImage)

        // The mask should already match the original dimensions, but verify
        // and scale only if there's a real mismatch (>1px difference).
        let needsScale = abs(maskCI.extent.width - originalCI.extent.width) > 1
                      || abs(maskCI.extent.height - originalCI.extent.height) > 1

        let finalMask: CIImage
        if needsScale {
            let sx = originalCI.extent.width / maskCI.extent.width
            let sy = originalCI.extent.height / maskCI.extent.height
            finalMask = maskCI.transformed(by: CGAffineTransform(scaleX: sx, y: sy))
        } else {
            finalMask = maskCI
        }

        // Blend: keep original pixels where mask is white, transparent elsewhere
        let clearBG = CIImage(color: .clear).cropped(to: originalCI.extent)

        guard let blendFilter = CIFilter(name: "CIBlendWithMask") else { return nil }
        blendFilter.setValue(originalCI, forKey: kCIInputImageKey)
        blendFilter.setValue(clearBG, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(finalMask, forKey: kCIInputMaskImageKey)

        guard let output = blendFilter.outputImage else { return nil }

        // Crop to the non-transparent bounding box for a tighter cutout
        let subjectBounds = croppedBounds(of: output, within: originalCI.extent)

        guard let resultCGImage = ciContext.createCGImage(output, from: subjectBounds) else {
            return nil
        }

        return UIImage(cgImage: resultCGImage, scale: 1.0, orientation: .up)
    }

    // MARK: – Auto-crop to subject bounds

    /// Finds the bounding box of non-transparent pixels, with a little padding.
    private func croppedBounds(of image: CIImage, within extent: CGRect) -> CGRect {
        guard let cgImage = ciContext.createCGImage(image, from: extent) else {
            return extent
        }

        let width = cgImage.width
        let height = cgImage.height
        guard width > 0, height > 0 else { return extent }

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        var pixels = [UInt8](repeating: 0, count: height * bytesPerRow)

        return pixels.withUnsafeMutableBytes { buffer in
            guard
                let baseAddress = buffer.baseAddress,
                let context = CGContext(
                    data: baseAddress,
                    width: width,
                    height: height,
                    bitsPerComponent: 8,
                    bytesPerRow: bytesPerRow,
                    space: colorSpace,
                    bitmapInfo: bitmapInfo
                )
            else {
                return extent
            }

            let pixelBytes = buffer.bindMemory(to: UInt8.self)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

            let alphaThreshold: UInt8 = 12
            var minX = width
            var minY = height
            var maxX = -1
            var maxY = -1

            for y in 0..<height {
                let rowOffset = y * bytesPerRow
                for x in 0..<width {
                    let alpha = pixelBytes[rowOffset + (x * bytesPerPixel) + 3]
                    guard alpha > alphaThreshold else { continue }

                    minX = min(minX, x)
                    minY = min(minY, y)
                    maxX = max(maxX, x)
                    maxY = max(maxY, y)
                }
            }

            guard maxX >= minX, maxY >= minY else {
                return extent
            }

            let padding = max(12, Int(CGFloat(min(width, height)) * 0.04))
            let croppedMinX = max(0, minX - padding)
            let croppedMinY = max(0, minY - padding)
            let croppedMaxX = min(width - 1, maxX + padding)
            let croppedMaxY = min(height - 1, maxY + padding)

            return CGRect(
                x: extent.minX + CGFloat(croppedMinX),
                y: extent.minY + CGFloat(croppedMinY),
                width: CGFloat(croppedMaxX - croppedMinX + 1),
                height: CGFloat(croppedMaxY - croppedMinY + 1)
            )
        }
    }
}

// MARK: – UIImage Orientation Normalisation

extension UIImage {
    /// Re-draws the image so that its `imageOrientation` is `.up` and the
    /// underlying CGImage pixel layout matches the visual orientation.
    func normalizedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalised = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalised ?? self
    }
}
