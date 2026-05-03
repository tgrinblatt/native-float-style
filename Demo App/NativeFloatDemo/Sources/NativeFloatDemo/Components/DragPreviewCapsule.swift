import SwiftUI

struct DragPreviewCapsule: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.regularMaterial, in: Capsule())
            .overlay(Capsule().stroke(Color(nsColor: .separatorColor), lineWidth: NativeFloatTokens.Border.hairline))
    }
}
