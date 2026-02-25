import SwiftUI
import KeyboardShortcuts

struct ShortcutSettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Keyboard Shortcut")
                .font(.headline)

            HStack {
                Text("Pick Color")
                    .foregroundStyle(.secondary)
                Spacer()
                KeyboardShortcuts.Recorder(for: .pickColor)
            }

            Text("Press the shortcut to pick a color from the screen and copy it to the clipboard.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(20)
        .frame(width: 320)
    }
}
