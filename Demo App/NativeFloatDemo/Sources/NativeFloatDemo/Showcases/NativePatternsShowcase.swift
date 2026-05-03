import SwiftUI

struct NativePatternsShowcase: View {
    @State private var tooltipText = "Hover over items to see tooltips"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Native Patterns")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Keyboard shortcuts, tooltips, drag-drop, and other macOS conventions.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("KEYBOARD SHORTCUTS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Active Shortcuts in This App") {
                        VStack(alignment: .leading, spacing: 8) {
                            shortcutRow(keys: "\u{21E7}\u{2318}D", action: "Toggle appearance")
                            shortcutRow(keys: "\u{2318}P", action: "Pin window")
                            shortcutRow(keys: "\u{2318}W", action: "Hide window (not close)")
                            shortcutRow(keys: "\u{2318}Q", action: "Quit app")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("TOOLTIPS (.help)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Every toolbar button gets .help()") {
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                Image(systemName: "moon")
                            }
                            .help("Toggle appearance (\u{21E7}\u{2318}D)")

                            Button(action: {}) {
                                Image(systemName: "circle.fill")
                            }
                            .help("Window opacity")

                            Button(action: {}) {
                                Image(systemName: "pin")
                            }
                            .help("Pin window (\u{2318}P)")
                        }
                        Text("Hover over the buttons above to see tooltips")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CONTENT SHAPE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: ".contentShape(Rectangle())") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Makes the entire card area tappable, not just the text content.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Applied to all interactive cards and list rows.")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SCROLL INDICATORS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: ".scrollIndicators(.hidden)") {
                        Text("All scroll views hide indicators for a cleaner look. The content in this demo uses this pattern throughout.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("DRAG AND DROP")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Pattern") {
                        VStack(alignment: .leading, spacing: 8) {
                            bulletPoint(".onDrag provides NSItemProvider with UUID string")
                            bulletPoint("Custom drag preview: .regularMaterial capsule")
                            bulletPoint(".onDrop handles at destination (folder rows, zones)")
                            bulletPoint("Never move items on drag \u{2014} copy semantics")
                        }
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private func shortcutRow(keys: String, action: String) -> some View {
        HStack {
            Text(keys)
                .font(.system(.caption, design: .monospaced))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color(nsColor: .controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
                )
            Text(action)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\u{2022}").foregroundStyle(.secondary)
            Text(text).font(.caption).foregroundStyle(.secondary)
        }
    }
}
