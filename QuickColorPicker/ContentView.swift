import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var colorStore: ColorStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 0) {
            // ── Top: last copied color ──────────────────────────
            colorPreviewSection

            Divider()
                .padding(.horizontal, 8)

            // ── Bottom: menu buttons ────────────────────────────
            VStack(spacing: 2) {
                MenuButtonView(label: "Shortcut Settings", icon: "keyboard") {
                    openWindow(id: "shortcut-settings")
                    NSApp.activate(ignoringOtherApps: true)
                }

                MenuButtonView(label: "Quit", icon: "power") {
                    NSApp.terminate(nil)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
        }
        .frame(width: 240)
        .background(.ultraThinMaterial)
    }

    // MARK: - Color Preview

    private var colorPreviewSection: some View {
        VStack(spacing: 10) {
            // Color swatch
            RoundedRectangle(cornerRadius: 10)
                .fill(colorStore.color)
                .frame(height: 72)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: colorStore.color.opacity(0.6), radius: 8, y: 4)

            // Copied value + copy button
            HStack(spacing: 6) {
                Text(colorStore.copiedValue)
                    .font(.system(.callout, design: .monospaced).weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(colorStore.copiedValue, forType: .string)
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help("Copy to clipboard")
            }

            // HEX / RGB radio picker
            Picker("", selection: $colorStore.copyFormat) {
                ForEach(CopyFormat.allCases, id: \.self) { format in
                    Text(format.rawValue).tag(format)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 120)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 14)
    }
}

#Preview {
    ContentView()
        .environmentObject(ColorStore.shared)
}
