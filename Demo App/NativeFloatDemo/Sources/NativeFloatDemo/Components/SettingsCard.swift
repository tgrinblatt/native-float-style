import SwiftUI

struct SettingsCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)

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
}
