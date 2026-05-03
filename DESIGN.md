# Native Float — Design Specification

A macOS Tahoe+ SwiftUI design system that feels like a first-party Apple app. System fonts, native materials, minimal custom tokens. Identity comes from two core marks: the HoverToggles cluster and the frosted sidebar treatment.

---

## 1. Philosophy

1. **Apple-native first**: Use system APIs, system fonts, system colors. Only add custom values when Apple genuinely doesn't provide what's needed.
2. **Let Tahoe do the work**: Don't manually apply glass effects — `.primaryAction` toolbar items get auto-glass. Don't override system selection styling. Don't fight the framework.
3. **Two custom colors, that's it**: Light canvas `#EBEFEF` and dark card `#282828`. Everything else is system.
4. **The identity is behavior, not decoration**: HoverToggles (pin/opacity/appearance) and the sidebar treatment ARE the brand. No custom color palette needed.
5. **Spring animations only**: No linear, no easeIn/Out. Two springs cover everything.
6. **Minimize custom views**: If SwiftUI provides it natively (List, Toggle, NavigationSplitView), use the native version.

---

## 2. Platform Requirements

- macOS 26+ (Tahoe) — required for native toolbar glass grouping
- Swift 6.0+ (strict concurrency)
- SwiftUI (primary) + minimal AppKit (WindowAccessor only)
- Swift Package Manager (no Xcode project)
- SF Symbols for all icons

---

## 3. Color Tokens

### System Colors (use directly, no abstraction needed)
- **Canvas (dark mode)**: `.windowBackgroundColor` via NSColor
- **Card/control backgrounds**: `.controlBackgroundColor`
- **Borders**: `.separator`
- **Text primary**: default (no modifier)
- **Text secondary**: `.secondary`
- **Text tertiary**: `.tertiary`
- **Accent**: `.accentColor` (user's system preference)
- **Destructive**: `.red`
- **Success**: `.green`

### Custom Colors (only two)
```swift
// Light-mode canvas — warm grey, softer than pure white
static let lightCanvas = Color(red: 0xEB/255, green: 0xEF/255, blue: 0xEF/255) // #EBEFEF

// Dark-mode card — slightly lifted from window background for separation
static let darkCard = Color(red: 0x28/255, green: 0x28/255, blue: 0x28/255) // #282828
```

### Color Usage Pattern
```swift
@Environment(\.colorScheme) private var colorScheme

// Canvas background
colorScheme == .dark
    ? Color(nsColor: .windowBackgroundColor)
    : NativeFloatTokens.Color.lightCanvas

// Card background
colorScheme == .dark
    ? NativeFloatTokens.Color.darkCard
    : Color(nsColor: .controlBackgroundColor)
```

---

## 4. Typography

System fonts only. Never use `.custom()`. Use semantic text styles.

### Hierarchy
| Role | Style | Weight | Usage |
|------|-------|--------|-------|
| Display | `.largeTitle` | `.bold` | Hero numbers, empty states |
| Heading | `.title2` | `.semibold` | Section titles |
| Subheading | `.headline` | `.semibold` | Card titles, list headers |
| Body | `.body` | `.regular` | Primary content text |
| Secondary | `.subheadline` | `.regular` | Supporting text |
| Caption | `.caption` | `.regular` | Timestamps, metadata |
| Section label | `.caption` | `.medium` + `.secondary` + `.textCase(.uppercase)` | Sidebar section headers |
| Monospace data | `.body` + `.monospacedDigit()` | `.regular` | Numbers, counts, percentages |

### Rules
- No custom font registration
- No bundled fonts
- `.monospacedDigit()` for any numeric display (prevents layout shift)
- Section headers: `.font(.caption)` + `.foregroundStyle(.secondary)` + `.textCase(.uppercase)`

---

## 5. Spacing & Radius

### Spacing (5 values)
```swift
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}
```

### Corner Radius
```swift
enum Radius {
    static let sm: CGFloat = 6   // Small elements, tags
    static let md: CGFloat = 8   // Cards, containers
    static let lg: CGFloat = 10  // Settings cards, larger containers
    // Capsule() for search fields, pills, drag previews
}
```

All rounded rectangles use `.continuous` corner style (smooth curves, not circular arcs).

---

## 6. Shadow System

### Base Shadow (every card)
```swift
.shadow(color: .black.opacity(0.05), radius: 2, y: 1)
```

### Selected State (stacked — both applied simultaneously)
```swift
.shadow(color: .black.opacity(0.30), radius: 6, y: 2)   // close
.shadow(color: .black.opacity(0.40), radius: 22, y: 12)  // ambient
```

### Dark Mode Halo (dark mode only, selected cards)
```swift
.shadow(color: .white.opacity(0.30), radius: 8)
```

### Status Rings (conditional, on cards)
```swift
// Active/latest state
.overlay(RoundedRectangle(cornerRadius: 8).stroke(.green, lineWidth: 2))
.shadow(color: .green.opacity(0.35), radius: 6)

// Secondary state
.overlay(RoundedRectangle(cornerRadius: 8).stroke(.pink.opacity(0.7), lineWidth: 2))
.shadow(color: .pink.opacity(0.35), radius: 6)
```

---

## 7. Animation

Two springs. That's the entire motion system.

### Selection Spring (fast, snappy)
```swift
.spring(response: 0.28, dampingFraction: 0.7)
```
Used for: card selection, toggle state changes, button press feedback, opacity preset selection.

### Layout Spring (smooth, gentle)
```swift
.spring(response: 0.35, dampingFraction: 0.75)
```
Used for: grid layout changes, sidebar collapse/expand, view transitions, content appearing/disappearing.

### Transitions
```swift
// Item appearing
.transition(.scale(scale: 0.85).combined(with: .opacity))

// Item disappearing
.transition(.opacity)

// Drop target highlight
.animation(.easeInOut(duration: 0.15))  // exception: drop targets use easeInOut
```

### Scale Effect (selection)
```swift
.scaleEffect(isSelected ? 1.03 : 1.0)  // subtle lift, no reflow
```

---

## 8. Sidebar Treatment

The sidebar IS a core identity mark. Every Native Float app has this structure.

### Architecture
```swift
NavigationSplitView(columnVisibility: $columnVisibility) {
    SidebarView(...)
        .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
} detail: {
    CanvasView(...)
}
.navigationSplitViewStyle(.balanced)
```

### Title Row (top of sidebar, inline with traffic lights)
```swift
HStack {
    Text("App Name")
        .font(.headline)
        .fontWeight(.semibold)
    Spacer()
    Button(action: { /* navigate to settings */ }) {
        Image(systemName: "gearshape")
            .foregroundStyle(.secondary)
    }
    .buttonStyle(.plain)
}
.padding(.horizontal, 16)
.padding(.top, 12)
```

### Search Field
```swift
HStack(spacing: 6) {
    Image(systemName: "magnifyingglass")
        .foregroundStyle(.secondary)
    TextField("Search", text: $searchText)
        .textFieldStyle(.plain)
}
.padding(.horizontal, 10)
.padding(.vertical, 6)
.background(Color(nsColor: .controlBackgroundColor))
.clipShape(Capsule())
.overlay(Capsule().stroke(Color(nsColor: .separatorColor), lineWidth: 0.5))
```

### Section Headers
```swift
Text("SECTION NAME")
    .font(.caption)
    .foregroundStyle(.secondary)
    .textCase(.uppercase)
```

### List Style
```swift
List(selection: $selectedItem) { ... }
    .listStyle(.sidebar)
```

### Background
The sidebar's `.ultraThinMaterial` extends into the title bar zone automatically when using `NavigationSplitView` with `.windowStyle(.hiddenTitleBar)`.

---

## 9. HoverToggles Cluster

The HoverToggles ARE the second identity mark. Three separate toolbar items that Tahoe groups visually.

### Critical Rule
Each toggle is its own `ToolbarItem(.primaryAction)`. Never combine into one HStack or ToolbarItemGroup. Tahoe's auto-grouping only works correctly with separate items.

### Appearance Toggle
```swift
ToolbarItem(placement: .primaryAction) {
    Button(action: { toggleAppearance() }) {
        Image(systemName: colorScheme == .dark ? "sun.max" : "moon")
    }
    .help("Toggle appearance (⇧⌘D)")
    .keyboardShortcut("d", modifiers: [.shift, .command])
}
```

### Opacity Control
```swift
ToolbarItem(placement: .primaryAction) {
    Button(action: { showOpacityPopover = true }) {
        HStack(spacing: 4) {
            Image(systemName: opacityIcon)
            Text("\(Int(settings.windowOpacity * 100))%")
                .font(.caption)
                .monospacedDigit()
        }
    }
    .popover(isPresented: $showOpacityPopover, arrowEdge: .bottom) {
        OpacityPopoverContent(opacity: $settings.windowOpacity)
    }
}
```

Opacity icon logic:
- `>= 0.95`: `"circle.fill"`
- `>= 0.60`: `"circle.lefthalf.filled"`
- `< 0.60`: `"circle.dotted"`

Opacity presets: `[0.25, 0.35, 0.50, 0.70, 0.85, 1.00]`

### Pin Toggle
```swift
ToolbarItem(placement: .primaryAction) {
    Toggle(isOn: $settings.windowPinned) {
        Image(systemName: "pin")
    }
    .toggleStyle(.button)
    .help("Pin window (⌘P)")
    .keyboardShortcut("p", modifiers: .command)
}
```

The `Toggle(.button)` style gives automatic blue accent tint when active — no manual color needed.

---

## 10. WindowAccessor Pattern

Bridges SwiftUI to NSWindow for properties SwiftUI doesn't expose.

### Key Design Decisions
1. **Takes primitive values, NOT @Bindable**: SwiftUI's `updateNSView` only fires when struct properties differ. Observable reference changes don't trigger re-invocation.
2. **Applied as `.background()`**: Invisible, doesn't affect layout.
3. **HideOnCloseDelegate**: Intercepts `windowShouldClose` to call `orderOut(nil)` instead of closing.

### Properties Managed
- `window.level`: `.floating` (pinned) or `.normal` (unpinned)
- `window.backgroundColor`: Dynamic — light canvas with alpha, or window background
- `window.collectionBehavior`: `.canJoinAllSpaces` when show-on-all-desktops
- `window.isOpaque`: false (for opacity < 1.0)

### Usage
```swift
.background(WindowAccessor(
    isPinned: settings.windowPinned,
    opacity: settings.windowOpacity,
    showOnAllDesktops: settings.showOnAllDesktops
))
```

---

## 11. Toolbar Architecture

### Window Style
```swift
WindowGroup {
    ContentView()
}
.windowStyle(.hiddenTitleBar)
```

### Toolbar Background
```swift
.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
```

### Item Placement
| Slot | Placement | Content |
|------|-----------|---------|
| Sidebar toggle | `.navigation` | Auto-inserted by NavigationSplitView |
| App name | (in sidebar title row) | Not in toolbar — lives in sidebar content |
| HoverToggles | `.primaryAction` (×3) | Appearance, Opacity, Pin |
| Destructive actions | `.primaryAction` | Clear/delete menu (if applicable) |

### Rules
- Don't add custom Capsule backgrounds — Tahoe handles glass wrapping
- Don't use `.toolbar(.visible)` — let the system decide
- Each HoverToggle is its own ToolbarItem
- Use `.help()` on every toolbar button for tooltip accessibility

---

## 12. Card Pattern

### Structure
```swift
VStack(alignment: .leading, spacing: 8) {
    // card content
}
.padding(12)
.background(
    RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(colorScheme == .dark
            ? NativeFloatTokens.Color.darkCard
            : Color(nsColor: .controlBackgroundColor))
)
.overlay(
    RoundedRectangle(cornerRadius: 8, style: .continuous)
        .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
)
.shadow(color: .black.opacity(0.05), radius: 2, y: 1)
```

### Selection State
```swift
.scaleEffect(isSelected ? 1.03 : 1.0)
.shadow(color: .black.opacity(isSelected ? 0.30 : 0.05), radius: isSelected ? 6 : 2, y: isSelected ? 2 : 1)
.shadow(color: .black.opacity(isSelected ? 0.40 : 0), radius: isSelected ? 22 : 0, y: isSelected ? 12 : 0)
.animation(NativeFloatTokens.Motion.selection, value: isSelected)
```

---

## 13. Settings Pattern

Settings are accessed via the gear icon in the sidebar title row. They render as in-canvas content (not a separate Settings scene — though a `Settings {}` scene can also exist for the app menu).

### SettingsCard Component
```swift
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
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(nsColor: .separatorColor), lineWidth: 0.5)
        )
    }
}
```

---

## 14. Native Conventions

### Keyboard Shortcuts
- Pin: `⌘P`
- Toggle appearance: `⇧⌘D`
- Search focus: `⌘F` (if applicable)
- Close window: `⌘W` (hide, not quit — via HideOnCloseDelegate)

### Tooltips
Every toolbar button gets `.help("Description (shortcut)")`.

### Context Menus
```swift
.contextMenu {
    Button("Open") { }
    Button("Rename") { }
    Divider()
    Button("Delete", role: .destructive) { }
}
```

### Confirmation Dialogs
```swift
.confirmationDialog("Clear all items?", isPresented: $showConfirmation) {
    Button("Clear All", role: .destructive) { clearAll() }
    Button("Cancel", role: .cancel) { }
}
```

### Drag and Drop
- `.onDrag`: Provide `NSItemProvider` with UUID string
- Custom drag preview: `.regularMaterial` capsule with item title
- `.onDrop`: Handle at destination (folder rows, zones)

### ScrollView
```swift
ScrollView {
    LazyVGrid(columns: [.init(.adaptive(minimum: 200, maximum: 280))], spacing: 16) {
        // cards
    }
    .padding(24)
}
.scrollIndicators(.hidden)
```

---

## 15. Anti-Patterns

### Never Do
- Use `.custom()` fonts — system fonts only
- Hardcode hex colors beyond the 2 approved custom values
- Apply `.glassEffect()` manually — let Tahoe handle toolbar glass
- Combine HoverToggle items into one ToolbarItem or HStack
- Use `ToolbarItemGroup` for the HoverToggles cluster
- Pass `@Bindable` or `@Observable` to WindowAccessor
- Override `.listStyle` on the sidebar (it's `.sidebar` by default in NavigationSplitView)
- Use `.linear` or `.easeIn/.easeOut` animations (springs only)
- Add custom backgrounds to toolbar items (doubles up with Tahoe glass)
- Use `.windowToolbarStyle(.unified)` (re-enables opaque title bar)
- Add `.toolbarBackground(.visible)` (fights hidden title bar)
- Use circular corner arcs — always `.continuous`
- Create a separate Settings window for primary settings (use in-canvas cards)
- Make the sidebar opaque — `.ultraThinMaterial` is load-bearing for the identity

### Prefer
- `.separator` over any custom border color
- `.controlBackgroundColor` over custom light backgrounds
- `Toggle(.button)` over custom toggle implementations
- `.help()` tooltips over custom hover states
- `.confirmationDialog` over custom alert views
- `NavigationSplitView` over manual sidebar implementations
- `LazyVGrid(.adaptive)` over fixed-column grids
- `.background(WindowAccessor(...))` over `onAppear { NSApp.windows... }`
