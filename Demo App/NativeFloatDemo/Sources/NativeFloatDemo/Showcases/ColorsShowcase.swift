import SwiftUI

struct ColorsShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Colors")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("System colors + 2 custom values. That's the entire palette.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CUSTOM COLORS (ONLY 2)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    HStack(spacing: 16) {
                        colorSwatch(
                            color: NativeFloatTokens.Color.lightCanvas,
                            name: "Light Canvas",
                            hex: "#EBEFEF",
                            usage: "Canvas background (light mode)"
                        )
                        colorSwatch(
                            color: NativeFloatTokens.Color.darkCard,
                            name: "Dark Card",
                            hex: "#282828",
                            usage: "Card background (dark mode)"
                        )
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SYSTEM COLORS USED")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 12) {
                        systemSwatch(color: Color(nsColor: .windowBackgroundColor), name: ".windowBackgroundColor", usage: "Canvas (dark)")
                        systemSwatch(color: Color(nsColor: .controlBackgroundColor), name: ".controlBackgroundColor", usage: "Cards, inputs")
                        systemSwatch(color: Color(nsColor: .separatorColor), name: ".separatorColor", usage: "Borders")
                        systemSwatch(color: .accentColor, name: ".accentColor", usage: "Interactive elements")
                        systemSwatch(color: .secondary, name: ".secondary", usage: "Secondary text")
                        systemSwatch(color: .red, name: ".red", usage: "Destructive actions")
                        systemSwatch(color: .green, name: ".green", usage: "Success states")
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CURRENT CANVAS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    HStack(spacing: 16) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(NativeFloatTokens.Color.lightCanvas)
                                .frame(height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
                                )
                            Text("Light Canvas")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(nsColor: .windowBackgroundColor))
                                .frame(height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
                                )
                            Text("Dark Canvas")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        VStack(spacing: 8) {
                            let current = colorScheme == .dark
                                ? Color(nsColor: .windowBackgroundColor)
                                : NativeFloatTokens.Color.lightCanvas
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(current)
                                .frame(height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .stroke(.blue, lineWidth: 2)
                                )
                            Text("Active (\(colorScheme == .dark ? "dark" : "light"))")
                                .font(.caption)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private func colorSwatch(color: Color, name: String, hex: String, usage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
                )
            Text(name).font(.subheadline).fontWeight(.medium)
            Text(hex).font(.caption).monospacedDigit().foregroundStyle(.secondary)
            Text(usage).font(.caption).foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }

    private func systemSwatch(color: Color, name: String, usage: String) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(color)
                .frame(width: 32, height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(.caption).fontWeight(.medium)
                Text(usage).font(.caption2).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.sm, style: .continuous)
                .fill(colorScheme == .dark
                    ? NativeFloatTokens.Color.darkCard
                    : Color(nsColor: .controlBackgroundColor))
        )
    }
}
