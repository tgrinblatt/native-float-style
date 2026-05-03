import SwiftUI

struct MaterialsShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Materials")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Native materials only. No manual .glassEffect() \u{2014} let Tahoe handle toolbar glass.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("MATERIALS USED")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    materialSamples
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("USAGE RULES")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    usageRules
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private var materialSamples: some View {
        VStack(spacing: 16) {
            materialRow(title: ".ultraThinMaterial", description: "Sidebar background. Extends into title bar zone.") {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(height: 60)
                    .overlay(
                        Text("Sidebar").font(.caption).foregroundStyle(.secondary)
                    )
            }

            materialRow(title: ".regularMaterial", description: "Drag preview capsules.") {
                HStack {
                    DragPreviewCapsule(title: "Dragged Item")
                    DragPreviewCapsule(title: "Another Item")
                }
            }

            materialRow(title: ".controlBackgroundColor", description: "Cards, search fields, settings containers.") {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .frame(height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
                    )
                    .overlay(
                        Text("Card / Input").font(.caption).foregroundStyle(.secondary)
                    )
            }

            materialRow(title: "Tahoe Auto-Glass", description: "Applied automatically to .primaryAction toolbar items. Never add manually.") {
                HStack(spacing: 8) {
                    toolbarItemPreview(icon: "moon")
                    toolbarItemPreview(icon: "circle.fill")
                    toolbarItemPreview(icon: "pin")
                }
            }
        }
    }

    private func materialRow<Content: View>(title: String, description: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline).fontWeight(.medium)
            Text(description).font(.caption).foregroundStyle(.secondary)
            content()
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

    private func toolbarItemPreview(icon: String) -> some View {
        Image(systemName: icon)
            .font(.body)
            .padding(8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    private var usageRules: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 12) {
            SettingsCard(title: "Do") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\u{2022} .ultraThinMaterial on sidebar")
                    Text("\u{2022} .regularMaterial for drag previews")
                    Text("\u{2022} .controlBackgroundColor for cards")
                    Text("\u{2022} Let Tahoe auto-glass toolbar items")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            SettingsCard(title: "Don't") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\u{2022} .glassEffect() manually")
                    Text("\u{2022} GlassEffectContainer")
                    Text("\u{2022} .buttonStyle(.glass)")
                    Text("\u{2022} Custom Capsule on toolbar items")
                }
                .font(.caption)
                .foregroundStyle(.red.opacity(0.8))
            }
        }
    }
}
