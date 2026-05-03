import SwiftUI

struct SidebarShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Sidebar Treatment")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("The frosted sidebar is a core identity mark. Look left \u{2190} for the live implementation.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("STRUCTURE")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    structureList
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("KEY PATTERNS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    patternsGrid
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SEARCH FIELD DEMO")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    searchFieldDemo
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private var structureList: some View {
        VStack(alignment: .leading, spacing: 8) {
            structureRow(number: "1", text: "Title row: app name (left) + gear button (right)")
            structureRow(number: "2", text: "Capsule search field with magnifying glass icon")
            structureRow(number: "3", text: "Divider")
            structureRow(number: "4", text: "Section headers: .caption + .secondary + uppercase")
            structureRow(number: "5", text: "List items: .listStyle(.sidebar) for native rows")
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.lg, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.lg, style: .continuous)
                .stroke(Color(nsColor: .separatorColor), lineWidth: NativeFloatTokens.Border.hairline)
        )
    }

    private func structureRow(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.accentColor)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
        }
    }

    private var patternsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 12) {
            SettingsCard(title: "Traffic Lights on Sidebar") {
                Text(".windowStyle(.hiddenTitleBar) removes the bar but keeps traffic lights. NavigationSplitView's sidebar material extends into the title bar zone automatically.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            SettingsCard(title: "Auto Collapse Toggle") {
                Text("NavigationSplitView auto-inserts a sidebar collapse toggle at .navigation placement. No manual button needed.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            SettingsCard(title: ".ultraThinMaterial") {
                Text("The sidebar background uses .ultraThinMaterial which extends behind the title bar zone. This is load-bearing for the identity.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            SettingsCard(title: "Column Width") {
                Text(".navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @State private var demoSearchText = ""

    private var searchFieldDemo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interactive search field (same as sidebar)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            SidebarSearchField(text: $demoSearchText)
                .frame(maxWidth: 300)

            if !demoSearchText.isEmpty {
                Text("Searching: \"\(demoSearchText)\"")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
