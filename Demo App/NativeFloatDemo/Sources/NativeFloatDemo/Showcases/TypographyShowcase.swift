import SwiftUI

struct TypographyShowcase: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Typography")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("System fonts only. Never use .custom(). Semantic text styles handle everything.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("TEXT STYLES")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    textStylesList
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("WEIGHT VARIATIONS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    weightsList
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SPECIAL TREATMENTS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    specialTreatments
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    private var textStylesList: some View {
        VStack(alignment: .leading, spacing: 16) {
            typeSample(style: ".largeTitle", font: .largeTitle, text: "Large Title")
            typeSample(style: ".title", font: .title, text: "Title")
            typeSample(style: ".title2", font: .title2, text: "Title 2")
            typeSample(style: ".title3", font: .title3, text: "Title 3")
            typeSample(style: ".headline", font: .headline, text: "Headline")
            typeSample(style: ".subheadline", font: .subheadline, text: "Subheadline")
            typeSample(style: ".body", font: .body, text: "Body — The quick brown fox jumps over the lazy dog")
            typeSample(style: ".callout", font: .callout, text: "Callout")
            typeSample(style: ".footnote", font: .footnote, text: "Footnote")
            typeSample(style: ".caption", font: .caption, text: "Caption")
            typeSample(style: ".caption2", font: .caption2, text: "Caption 2")
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

    private func typeSample(style: String, font: Font, text: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(style)
                .font(.caption)
                .foregroundStyle(.tertiary)
                .frame(width: 100, alignment: .trailing)
            Text(text)
                .font(font)
        }
    }

    private var weightsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("The quick brown fox").font(.title3).fontWeight(.bold)
            Text("The quick brown fox").font(.title3).fontWeight(.semibold)
            Text("The quick brown fox").font(.title3).fontWeight(.medium)
            Text("The quick brown fox").font(.title3).fontWeight(.regular)
            Text("The quick brown fox").font(.title3).fontWeight(.light)
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

    private var specialTreatments: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 12) {
            SettingsCard(title: "Section Headers") {
                Text("SECTION NAME")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }

            SettingsCard(title: "Monospaced Digits") {
                Text("1,234,567.89")
                    .font(.body)
                    .monospacedDigit()
            }

            SettingsCard(title: "Secondary Text") {
                Text("Supporting information")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            SettingsCard(title: "Tertiary Text") {
                Text("Timestamps, metadata")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
