import SwiftUI

struct LayoutShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Layout")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("NavigationSplitView, LazyVGrid, toolbar placement, and column constraints.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("NAVIGATION SPLIT VIEW")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Structure") {
                        VStack(alignment: .leading, spacing: 8) {
                            codeRow("NavigationSplitView(columnVisibility:) {")
                            codeRow("    SidebarView()")
                            codeRow("        .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)")
                            codeRow("} detail: {")
                            codeRow("    CanvasView()")
                            codeRow("}")
                            codeRow(".navigationSplitViewStyle(.balanced)")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("LAZY V GRID")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Adaptive Columns") {
                        VStack(alignment: .leading, spacing: 8) {
                            codeRow("LazyVGrid(")
                            codeRow("    columns: [GridItem(.adaptive(minimum: 200, maximum: 280))],")
                            codeRow("    spacing: 16")
                            codeRow(") { ... }")
                        }
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 280))], spacing: 16) {
                        ForEach(0..<8) { i in
                            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.md, style: .continuous)
                                .fill(Color(nsColor: .controlBackgroundColor))
                                .frame(height: 80)
                                .overlay(
                                    Text("Cell \(i + 1)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.md, style: .continuous)
                                        .stroke(Color(nsColor: .separatorColor), lineWidth: NativeFloatTokens.Border.hairline)
                                )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("TOOLBAR PLACEMENT")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Item Placement Map") {
                        VStack(alignment: .leading, spacing: 8) {
                            placementRow(slot: ".navigation", content: "Auto sidebar toggle", note: "Inserted by NavigationSplitView")
                            Divider()
                            placementRow(slot: ".primaryAction", content: "HoverToggles (\u{00D7}3)", note: "Separate items, Tahoe groups them")
                            Divider()
                            placementRow(slot: ".primaryAction", content: "Action menu", note: "Clear/delete (if applicable)")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("WINDOW SETUP")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Required Configuration") {
                        VStack(alignment: .leading, spacing: 8) {
                            codeRow(".windowStyle(.hiddenTitleBar)")
                            codeRow(".toolbarBackgroundVisibility(.hidden, for: .windowToolbar)")
                            codeRow("// AppDelegate:")
                            codeRow("window.titlebarAppearsTransparent = true")
                        }
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private func codeRow(_ text: String) -> some View {
        Text(text)
            .font(.system(.caption, design: .monospaced))
            .foregroundStyle(.secondary)
    }

    private func placementRow(slot: String, content: String, note: String) -> some View {
        HStack(alignment: .top) {
            Text(slot)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(Color.accentColor)
                .frame(width: 120, alignment: .leading)
            VStack(alignment: .leading, spacing: 2) {
                Text(content).font(.subheadline)
                Text(note).font(.caption).foregroundStyle(.tertiary)
            }
        }
    }
}
