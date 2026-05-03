# Design Tokens

## Colors

Native Float uses almost exclusively system colors. Only 2 custom values exist.

### Custom Colors
```swift
enum NativeFloatTokens {
    enum Color {
        // Light-mode canvas — warm grey, softer than pure white
        static let lightCanvas = SwiftUI.Color(red: 235/255, green: 239/255, blue: 239/255) // #EBEFEF

        // Dark-mode card — slightly lifted from window background for card separation
        static let darkCard = SwiftUI.Color(red: 40/255, green: 40/255, blue: 40/255) // #282828
    }
}
```

### System Colors Used Directly
| Purpose | Value |
|---------|-------|
| Canvas (dark mode) | `Color(nsColor: .windowBackgroundColor)` |
| Card/input backgrounds | `Color(nsColor: .controlBackgroundColor)` |
| Borders | `Color(nsColor: .separatorColor)` |
| Text secondary | `.secondary` |
| Text tertiary | `.tertiary` |
| Accent | `.accentColor` |
| Destructive | `.red` |
| Success | `.green` |

### Usage Pattern
```swift
@Environment(\.colorScheme) private var colorScheme

// Canvas background
let canvasBackground = colorScheme == .dark
    ? Color(nsColor: .windowBackgroundColor)
    : NativeFloatTokens.Color.lightCanvas

// Card background
let cardBackground = colorScheme == .dark
    ? NativeFloatTokens.Color.darkCard
    : Color(nsColor: .controlBackgroundColor)
```

## Spacing

```swift
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}
```

## Corner Radius

```swift
enum Radius {
    static let sm: CGFloat = 6   // Small elements, tags
    static let md: CGFloat = 8   // Cards, containers
    static let lg: CGFloat = 10  // Settings cards, larger containers
}
```

All corners use `RoundedRectangle(cornerRadius: N, style: .continuous)`.

Use `Capsule()` for: search fields, pills, drag previews.

## Borders

```swift
.overlay(
    RoundedRectangle(cornerRadius: 8, style: .continuous)
        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
)
```

Always `.separator` color. Always 0.5pt line width.

## Shadows

```swift
enum Shadow {
    // Every card gets this
    static let base = (color: Color.black.opacity(0.05), radius: 2.0, y: 1.0)

    // Selected card — apply BOTH close + ambient
    static let selectedClose = (color: Color.black.opacity(0.30), radius: 6.0, y: 2.0)
    static let selectedAmbient = (color: Color.black.opacity(0.40), radius: 22.0, y: 12.0)

    // Dark mode only — selected cards get a subtle white halo
    static let darkHalo = (color: Color.white.opacity(0.30), radius: 8.0)
}
```

## Motion

Two springs. No other animation types.

```swift
enum Motion {
    // Fast, snappy — card selection, toggle states, button feedback
    static let selection = Animation.spring(response: 0.28, dampingFraction: 0.7)

    // Smooth, gentle — layout changes, sidebar, view transitions
    static let layout = Animation.spring(response: 0.35, dampingFraction: 0.75)
}
```

### Transitions
- Item appearing: `.transition(.scale(scale: 0.85).combined(with: .opacity))`
- Item disappearing: `.transition(.opacity)`
- Selection scale: `.scaleEffect(isSelected ? 1.03 : 1.0)` (no frame change)
