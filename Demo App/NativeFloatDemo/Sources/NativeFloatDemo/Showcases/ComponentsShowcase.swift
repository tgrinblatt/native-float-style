import SwiftUI

struct ComponentsShowcase: View {
    @State private var selectedCard: Int? = 1
    @State private var showConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Components")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Cards, search fields, popovers, context menus, and confirmation dialogs.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CARDS (CLICK TO SELECT)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 280))], spacing: 16) {
                        ForEach(0..<6) { i in
                            DemoCard(
                                title: "Card \(i + 1)",
                                subtitle: "This demonstrates the card pattern with shadow system and selection state.",
                                isSelected: selectedCard == i
                            )
                            .onTapGesture { selectedCard = selectedCard == i ? nil : i }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SETTINGS CARDS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 12) {
                        SettingsCard(title: "Toggles") {
                            Toggle("First option", isOn: .constant(true))
                            Toggle("Second option", isOn: .constant(false))
                        }

                        SettingsCard(title: "Information") {
                            LabeledContent("Version", value: "1.0.0")
                            LabeledContent("Build", value: "42")
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("DRAG PREVIEW")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    HStack(spacing: 12) {
                        DragPreviewCapsule(title: "Clip Title")
                        DragPreviewCapsule(title: "Another Item")
                        DragPreviewCapsule(title: "Document.pdf")
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CONTEXT MENU")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    Text("Right-click the card below")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    DemoCard(title: "Right-Click Me", subtitle: "Context menu with standard actions")
                        .contextMenu {
                            Button("Open") { }
                            Button("Rename") { }
                            Divider()
                            Menu("Move to") {
                                Button("Folder A") { }
                                Button("Folder B") { }
                            }
                            Divider()
                            Button("Delete", role: .destructive) { }
                        }
                        .frame(maxWidth: 280)
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("CONFIRMATION DIALOG")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    Button("Show Confirmation") { showConfirmation = true }
                        .confirmationDialog(
                            "Clear all items?",
                            isPresented: $showConfirmation,
                            titleVisibility: .visible
                        ) {
                            Button("Clear All", role: .destructive) { }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("This action cannot be undone.")
                        }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }
}
