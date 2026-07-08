import AppKit

let size: CGFloat = 1024
let docW: CGFloat = 524
let docH: CGFloat = 676
let docX = (size - docW) / 2
let docY = (size - docH) / 2 + 30

let badgeSize: CGFloat = 240
let badgeX = size - docX - badgeSize + 20
let badgeY = docY - 20

let img = NSImage(size: NSSize(width: size, height: size), flipped: false) { rect in
    guard let ctx = NSGraphicsContext.current?.cgContext else { return false }
    ctx.setShouldAntialias(true)

    // Background: subtle gradient matching the brand
    let bgColors = [
        NSColor(calibratedRed: 0.90, green: 0.96, blue: 0.95, alpha: 1).cgColor,
        NSColor(calibratedRed: 0.85, green: 0.93, blue: 0.91, alpha: 1).cgColor,
    ]
    let loc: [CGFloat] = [0, 1]
    guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: bgColors as CFArray, locations: loc) else { return false }
    ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size, y: size), options: [])

    // Document shadow
    ctx.saveGState()
    let docShadow = NSShadow()
    docShadow.shadowBlurRadius = 40
    docShadow.shadowOffset = NSSize(width: 0, height: -8)
    docShadow.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.12)
    docShadow.set()

    // Document body
    let docPath = NSBezierPath(roundedRect: CGRect(x: docX, y: docY, width: docW, height: docH), xRadius: 48, yRadius: 48)
    NSColor.white.setFill()
    docPath.fill()
    ctx.restoreGState()

    // Fold (corner fold on top-right)
    let foldPath = NSBezierPath()
    foldPath.move(to: CGPoint(x: docX + docW - 100, y: docY + docH))
    foldPath.line(to: CGPoint(x: docX + docW, y: docY + docH - 100))
    foldPath.line(to: CGPoint(x: docX + docW - 100, y: docY + docH - 100))
    foldPath.close()
    NSColor(calibratedRed: 0.92, green: 0.95, blue: 0.94, alpha: 1).setFill()
    foldPath.fill()

    // Lines on document (representing text content)
    let lineColor = NSColor(calibratedRed: 0.78, green: 0.84, blue: 0.82, alpha: 1)
    lineColor.setStroke()
    for i in 0..<6 {
        let lineY = docY + docH - 160 - CGFloat(i) * 56
        let linePath = NSBezierPath()
        linePath.move(to: CGPoint(x: docX + 80, y: lineY))
        linePath.line(to: CGPoint(x: docX + docW - 100, y: lineY))
        linePath.lineWidth = 10
        linePath.lineCapStyle = .round
        linePath.stroke()
    }

    // Plus badge shadow
    ctx.saveGState()
    let badgeShadow = NSShadow()
    badgeShadow.shadowBlurRadius = 32
    badgeShadow.shadowOffset = NSSize(width: 0, height: -6)
    badgeShadow.shadowColor = NSColor(calibratedRed: 0.1, green: 0.4, blue: 0.6, alpha: 0.35)
    badgeShadow.set()

    // Plus badge background: cyan to blue gradient
    let badgeRect = CGRect(x: badgeX, y: badgeY, width: badgeSize, height: badgeSize)
    let badgePath = NSBezierPath(roundedRect: badgeRect, xRadius: 60, yRadius: 60)
    let badgeColors = [
        NSColor(calibratedRed: 0.094, green: 0.659, blue: 0.651, alpha: 1).cgColor,
        NSColor(calibratedRed: 0.227, green: 0.490, blue: 0.941, alpha: 1).cgColor,
    ]
    guard let badgeGrad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: badgeColors as CFArray, locations: loc) else { return false }
    ctx.addPath(badgePath.cgPath)
    ctx.clip()
    ctx.drawLinearGradient(badgeGrad, start: CGPoint(x: badgeRect.minX, y: badgeRect.minY), end: CGPoint(x: badgeRect.maxX, y: badgeRect.maxY), options: [])
    ctx.restoreGState()

    // Plus sign
    let plusColor = NSColor.white
    plusColor.setStroke()
    let plusThick: CGFloat = 24
    let plusLen: CGFloat = 100

    ctx.setLineWidth(plusThick)
    ctx.setLineCap(.round)

    // Horizontal line
    ctx.move(to: CGPoint(x: badgeX + (badgeSize - plusLen) / 2, y: badgeY + badgeSize / 2))
    ctx.addLine(to: CGPoint(x: badgeX + (badgeSize + plusLen) / 2, y: badgeY + badgeSize / 2))
    ctx.strokePath()

    // Vertical line
    ctx.move(to: CGPoint(x: badgeX + badgeSize / 2, y: badgeY + (badgeSize - plusLen) / 2))
    ctx.addLine(to: CGPoint(x: badgeX + badgeSize / 2, y: badgeY + (badgeSize + plusLen) / 2))
    ctx.strokePath()

    return true
}

// Save as PNG at 1024x1024 (1x)
let outputDir = "/tmp/jijian-icon"
try? FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: Int(size),
    pixelsHigh: Int(size),
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let drawRect = NSRect(x: 0, y: 0, width: size, height: size)
img.draw(in: drawRect)
NSGraphicsContext.restoreGraphicsState()

let pngPath = "\(outputDir)/icon_1024.png"
guard let data = rep.representation(using: .png, properties: [:]) else {
    print("Failed to encode PNG")
    exit(1)
}
try data.write(to: URL(fileURLWithPath: pngPath))
print("Generated: \(pngPath)")
