import Cocoa

@MainActor
func pickColorAndCopy(){
    let sampler = NSColorSampler()
    
    sampler.show {
        selectedColor in
        guard let color = selectedColor else {
            print("Cancel")
            return
        }

        let haxStr = color.toHex() ?? "#000000"
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(haxStr, forType: .string)
        print("copied \(haxStr) to pasteboard")
    }
}

extension NSColor {
    func toHex() -> String? {
        guard let rgbColor = usingColorSpace(.deviceRGB) else { return nil }
        
        let r = Int(round(rgbColor.redComponent * 255))
        let g = Int(round(rgbColor.greenComponent * 255))
        let b = Int(round(rgbColor.blueComponent * 255))
        
        return String(format:"#%02X%02X%02X",r, g, b)
    }
}
