import SwiftUI

struct HoverTogglesShowcase: View {
    @Bindable var settings: AppSettings
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("HoverToggles Cluster")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Three separate ToolbarItem(.primaryAction) items. Look at the toolbar above \u{2191} \u{2014} those are live.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CRITICAL RULE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Each toggle is its own ToolbarItem") {
                        Text("Never combine into one ToolbarItem, ToolbarItemGroup, or HStack. Tahoe auto-groups consecutive .primaryAction items into a single glass container at render time while preserving individual styling.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 280))], spacing: 16) {
                    appearanceCard
                    opacityCard
                    pinCard
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.md) {
                    Text("LIVE STATE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Current Values") {
                        LabeledContent("Appearance", value: settings.appearance)
                        LabeledContent("Opacity", value: "\(Int(settings.windowOpacity * 100))%")
                        LabeledContent("Pinned", value: settings.windowPinned ? "Yes" : "No")
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private var appearanceCard: some View {
        SettingsCard(title: "Appearance Toggle") {
            VStack(alignment: .leading, spacing: 8) {
                Label("Binary light/dark switch", systemImage: colorScheme == .dark ? "sun.max" : "moon")
                    .font(.subheadline)
                Text("Icon reflects current state. Click to switch.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Shortcut: \u{21E7}\u{2318}D")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private var opacityCard: some View {
        SettingsCard(title: "Opacity Control") {
            VStack(alignment: .leading, spacing: 8) {
                Label("Button + popover", systemImage: "circle.lefthalf.filled")
                    .font(.subheadline)
                Text("Shows icon + percentage. Opens popover with slider and 6 presets (25/35/50/70/85/100).")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Text("Icons:").font(.caption).foregroundStyle(.tertiary)
                    Image(systemName: "circle.fill")
                    Text("\u{2265}95%").font(.caption2)
                    Image(systemName: "circle.lefthalf.filled")
                    Text("\u{2265}60%").font(.caption2)
                    Image(systemName: "circle.dotted")
                    Text("<60%").font(.caption2)
                }
                .foregroundStyle(.secondary)
            }
        }
    }

    private var pinCard: some View {
        SettingsCard(title: "Pin Toggle") {
            VStack(alignment: .leading, spacing: 8) {
                Label("Toggle(.button) for native blue accent", systemImage: "pin")
                    .font(.subheadline)
                Text("Automatic blue tint when active. WindowAccessor sets window.level = .floating.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Shortcut: \u{2318}P")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
