import SwiftUI

struct DemoCard: View {
    let title: String
    let subtitle: String
    var isSelected: Bool = false

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .lineLimit(2)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.md, style: .continuous)
                .fill(colorScheme == .dark
                    ? NativeFloatTokens.Color.darkCard
                    : Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: NativeFloatTokens.Radius.md, style: .continuous)
                .stroke(
                    isSelected && colorScheme == .dark
                        ? Color.white.opacity(0.45)
                        : Color(nsColor: .separatorColor),
                    lineWidth: isSelected && colorScheme == .dark ? 1 : NativeFloatTokens.Border.hairline
                )
        )
        .shadow(
            color: NativeFloatTokens.Shadow.baseColor,
            radius: NativeFloatTokens.Shadow.baseRadius,
            y: NativeFloatTokens.Shadow.baseY
        )
        .shadow(
            color: isSelected ? NativeFloatTokens.Shadow.selectedCloseColor : .clear,
            radius: isSelected ? NativeFloatTokens.Shadow.selectedCloseRadius : 0,
            y: isSelected ? NativeFloatTokens.Shadow.selectedCloseY : 0
        )
        .shadow(
            color: isSelected ? NativeFloatTokens.Shadow.selectedAmbientColor : .clear,
            radius: isSelected ? NativeFloatTokens.Shadow.selectedAmbientRadius : 0,
            y: isSelected ? NativeFloatTokens.Shadow.selectedAmbientY : 0
        )
        .scaleEffect(isSelected ? 1.03 : 1.0)
        .animation(NativeFloatTokens.Motion.selection, value: isSelected)
        .contentShape(Rectangle())
    }
}
