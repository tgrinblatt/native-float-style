import SwiftUI

enum NativeFloatTokens {
    enum Color {
        static let lightCanvas = SwiftUI.Color(red: 235 / 255, green: 239 / 255, blue: 239 / 255)
        static let darkCard = SwiftUI.Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255)
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
        static let lg: CGFloat = 10
    }

    enum Shadow {
        static let baseColor = SwiftUI.Color.black.opacity(0.05)
        static let baseRadius: CGFloat = 2
        static let baseY: CGFloat = 1

        static let selectedCloseColor = SwiftUI.Color.black.opacity(0.30)
        static let selectedCloseRadius: CGFloat = 6
        static let selectedCloseY: CGFloat = 2

        static let selectedAmbientColor = SwiftUI.Color.black.opacity(0.40)
        static let selectedAmbientRadius: CGFloat = 22
        static let selectedAmbientY: CGFloat = 12

        static let darkHaloColor = SwiftUI.Color.white.opacity(0.30)
        static let darkHaloRadius: CGFloat = 8
    }

    enum Motion {
        static let selection = Animation.spring(response: 0.28, dampingFraction: 0.7)
        static let layout = Animation.spring(response: 0.35, dampingFraction: 0.75)
    }

    enum Border {
        static let hairline: CGFloat = 0.5
    }
}
