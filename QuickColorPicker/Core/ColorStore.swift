import SwiftUI
import Combine

enum CopyFormat: String, CaseIterable {
    case hex = "HEX"
    case rgb = "RGB"
}

class ColorStore: ObservableObject {
    static let shared = ColorStore()

    // Last copied color hex — persisted in UserDefaults
    @Published var lastHex: String {
        didSet { UserDefaults.standard.set(lastHex, forKey: "lastHex") }
    }

    // Copy format preference — persisted in UserDefaults
    @Published var copyFormat: CopyFormat {
        didSet { UserDefaults.standard.set(copyFormat.rawValue, forKey: "copyFormat") }
    }

    private init() {
        self.lastHex = UserDefaults.standard.string(forKey: "lastHex") ?? "#FFFFFF"
        let savedFormat = UserDefaults.standard.string(forKey: "copyFormat") ?? CopyFormat.hex.rawValue
        self.copyFormat = CopyFormat(rawValue: savedFormat) ?? .hex
    }

    var color: Color {
        Color(hex: lastHex) ?? .white
    }

    var nsColor: NSColor {
        NSColor(hex: lastHex) ?? .white
    }

    // The string that gets copied to clipboard (depends on format)
    var copiedValue: String {
        switch copyFormat {
        case .hex:
            return lastHex.uppercased()
        case .rgb:
            let c = nsColor
            var r: CGFloat = 0; var g: CGFloat = 0; var b: CGFloat = 0
            c.usingColorSpace(.deviceRGB)?.getRed(&r, green: &g, blue: &b, alpha: nil)
            return "rgb(\(Int(r*255)), \(Int(g*255)), \(Int(b*255)))"
        }
    }
}

// MARK: - Color+Hex helpers

extension Color {
    init?(hex: String) {
        guard let ns = NSColor(hex: hex) else { return nil }
        self.init(ns)
    }
}

extension NSColor {
    convenience init?(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if h.hasPrefix("#") { h = String(h.dropFirst()) }
        guard h.count == 6, let value = UInt64(h, radix: 16) else { return nil }
        let r = CGFloat((value >> 16) & 0xFF) / 255
        let g = CGFloat((value >> 8)  & 0xFF) / 255
        let b = CGFloat( value        & 0xFF) / 255
        self.init(srgbRed: r, green: g, blue: b, alpha: 1)
    }
}
