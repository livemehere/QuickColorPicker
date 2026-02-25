import SwiftUI
import KeyboardShortcuts
import Cocoa

extension KeyboardShortcuts.Name {
    static let pickColor = Self("pickColor", default: .init(.c, modifiers: [.command, .shift]))
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var isPicking = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        KeyboardShortcuts.onKeyUp(for: .pickColor) { [weak self] in
            guard let self = self else { return }

            guard !self.isPicking else {
                print("Already picking.")
                return
            }

            self.isPicking = true
            print("Picking..")

            DispatchQueue.main.async {
                let sampler = NSColorSampler()
                sampler.show { selectedColor in
                    self.isPicking = false

                    guard let color = selectedColor else {
                        print("Cancelled.")
                        return
                    }

                    let hexStr = color.toHex() ?? "#000000"

                    DispatchQueue.main.async {
                        ColorStore.shared.lastHex = hexStr
                        let value = ColorStore.shared.copiedValue
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(value, forType: .string)
                        print("Copied to clipboard: \(value)")
                    }
                }
            }
        }
    }
}

@main
struct QuickColorPickerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Quick Color Picker", systemImage: "pencil.and.ellipsis.rectangle") {
            ContentView()
                .environmentObject(ColorStore.shared)
        }
        .menuBarExtraStyle(.window)

        Window("단축키 설정", id: "shortcut-settings") {
            ShortcutSettingsView()
        }
        .windowResizability(.contentSize)
    }
}
