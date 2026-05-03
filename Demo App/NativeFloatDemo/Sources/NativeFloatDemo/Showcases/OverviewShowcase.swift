import SwiftUI

struct OverviewShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Native Float")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("A macOS Tahoe+ style that feels like a first-party Apple app. System fonts, native materials, minimal custom tokens.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("ANATOMY")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    anatomyDiagram
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("IDENTITY MARKS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    identityGrid
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("DESIGN PRINCIPLES")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    principlesGrid
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private var anatomyDiagram: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 4) {
                    Circle().fill(.red).frame(width: 10, height: 10)
                    Circle().fill(.orange).frame(width: 10, height: 10)
                    Circle().fill(.green).frame(width: 10, height: 10)
                }
                Text("\u{229F}")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Spacer()
                HStack(spacing: 12) {
                    Image(systemName: "moon")
                    HStack(spacing: 4) {
                        Image(systemName: "circle.fill")
                        Text("100%").font(.caption)
                    }
                    Image(systemName: "pin")
                }
                .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(Color(nsColor: .controlBackgroundColor))

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("App Name").font(.headline)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(nsColor: .controlBackgroundColor))
                        .frame(height: 28)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.tertiary)
                                Spacer()
                            }.padding(.horizontal, 8)
                        )
                    Divider()
                    Text("SECTION").font(.caption).foregroundStyle(.secondary)
                    ForEach(["Item One", "Item Two", "Item Three"], id: \.self) { item in
                        Text(item).font(.body).padding(.vertical, 2)
                    }
                    Spacer()
                }
                .frame(width: 160)
                .padding(12)
                .background(.ultraThinMaterial)

                VStack {
                    Text("CANVAS AREA")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(12)
            }
            .frame(height: 200)
        }
        .clipShape(RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.md, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.md, style: .continuous)
                .stroke(Color(nsColor: .separatorColor), lineWidth: NativeFloatTokens.Border.hairline)
        )
    }

    private var identityGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 16) {
            SettingsCard(title: "HoverToggles Cluster") {
                Text("Three separate .primaryAction toolbar items: Appearance, Opacity, Pin. Tahoe auto-groups them visually.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            SettingsCard(title: "Frosted Sidebar") {
                Text("NavigationSplitView with .ultraThinMaterial. Traffic lights on sidebar. Title row with app name + gear.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            SettingsCard(title: "WindowAccessor Bridge") {
                Text("NSViewRepresentable taking primitive values. Pin/float, opacity, show-on-all-desktops, hide-on-close.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var principlesGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 12) {
            principleItem(icon: "textformat", title: "System Fonts", description: "Semantic styles only")
            principleItem(icon: "paintpalette", title: "2 Custom Colors", description: "#EBEFEF + #282828")
            principleItem(icon: "wand.and.stars", title: "Springs Only", description: "Two springs, no linear")
            principleItem(icon: "square.on.square", title: "Native Materials", description: "Let Tahoe handle glass")
            principleItem(icon: "pin", title: "Behavior Identity", description: "Not decoration")
            principleItem(icon: "apple.logo", title: "Apple-Native First", description: "System APIs always")
        }
    }

    private func principleItem(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.medium)
                Text(description).font(.caption).foregroundStyle(.secondary)
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
