# HoverToggles Cluster

The HoverToggles cluster is one of two identity marks in Native Float. It provides quick access to window-level controls: appearance, opacity, and pin/float.

## Architecture

Three **separate** `ToolbarItem(.primaryAction)` items. macOS Tahoe automatically groups consecutive `.primaryAction` items into a single glass container at render time while preserving individual styling.

**Critical rule:** Never combine into one `ToolbarItem`, `ToolbarItemGroup`, or wrap in an `HStack`. This breaks:
- The pin toggle's automatic blue accent tint
- Tahoe's visual grouping behavior
- Individual item spacing

## Appearance Toggle

Binary light/dark switch. Icon reflects **current** state (click to switch to opposite).

```swift
ToolbarItem(placement: .primaryAction) {
    Button(action: {
        settings.appearance = settings.appearance == .dark ? .light : .dark
    }) {
        Image(systemName: colorScheme == .dark ? "sun.max" : "moon")
    }
    .help("Toggle appearance (⇧⌘D)")
    .keyboardShortcut("d", modifiers: [.shift, .command])
}
```

Implementation notes:
- Icon when dark: `sun.max` (clicking will switch to light)
- Icon when light: `moon` (clicking will switch to dark)
- No custom pill background — Tahoe handles it
- Shortcut: `⇧⌘D`

## Opacity Control

Button showing icon + percentage. Opens a popover with slider and 6 preset chips.

```swift
ToolbarItem(placement: .primaryAction) {
    Button(action: { showOpacityPopover = true }) {
        HStack(spacing: 4) {
            Image(systemName: opacityIcon(for: settings.windowOpacity))
            Text("\(Int(settings.windowOpacity * 100))%")
                .font(.caption)
                .monospacedDigit()
        }
    }
    .popover(isPresented: $showOpacityPopover, arrowEdge: .bottom) {
        OpacityPopoverContent(opacity: $settings.windowOpacity)
    }
    .help("Window opacity")
}
```

### Icon Logic
```swift
func opacityIcon(for value: Double) -> String {
    if value >= 0.95 { return "circle.fill" }
    if value >= 0.60 { return "circle.lefthalf.filled" }
    return "circle.dotted"
}
```

### Preset Chips
Values: `[0.25, 0.35, 0.50, 0.70, 0.85, 1.00]`

Each chip is a capsule button:
- Active preset: accent color background at 0.2 opacity, accent text
- Inactive: `.controlBackgroundColor`, primary text
- Animation on selection: `.easeOut(duration: 0.15)`

### Popover Content
```swift
struct OpacityPopoverContent: View {
    @Binding var opacity: Double
    private let presets: [Double] = [0.25, 0.35, 0.50, 0.70, 0.85, 1.00]

    var body: some View {
        VStack(spacing: 12) {
            Slider(value: $opacity, in: 0.25...1.0)

            HStack(spacing: 8) {
                ForEach(presets, id: \.self) { preset in
                    Button("\(Int(preset * 100))%") {
                        withAnimation(.easeOut(duration: 0.15)) {
                            opacity = preset
                        }
                    }
                    .buttonStyle(.plain)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(
                            opacity == preset
                                ? Color.accentColor.opacity(0.2)
                                : Color(nsColor: .controlBackgroundColor)
                        )
                    )
                    .foregroundStyle(opacity == preset ? .accentColor : .primary)
                }
            }
        }
        .padding(16)
        .frame(width: 280)
    }
}
```

## Pin Toggle

Window pin/float control using `Toggle(.button)` for automatic blue accent when active.

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

Implementation notes:
- `Toggle(.button)` gives automatic blue tint when on — no manual coloring
- WindowAccessor reads `settings.windowPinned` and sets `window.level = .floating`
- Shortcut: `⌘P`

## WindowAccessor Connection

The HoverToggles modify `AppSettings` properties. `WindowAccessor` (applied as `.background(...)` on the root view) reads these and applies to the NSWindow:

```swift
.background(WindowAccessor(
    isPinned: settings.windowPinned,        // → window.level
    opacity: settings.windowOpacity,         // → window.backgroundColor alpha
    showOnAllDesktops: settings.showOnAllDesktops  // → collectionBehavior
))
```

The appearance toggle modifies the color scheme override:
```swift
.preferredColorScheme(settings.appearance == .system ? nil : (settings.appearance == .dark ? .dark : .light))
```

## Complete Toolbar Example

```swift
.toolbar {
    // Appearance toggle
    ToolbarItem(placement: .primaryAction) {
        Button(action: { toggleAppearance() }) {
            Image(systemName: colorScheme == .dark ? "sun.max" : "moon")
        }
        .help("Toggle appearance (⇧⌘D)")
        .keyboardShortcut("d", modifiers: [.shift, .command])
    }

    // Opacity control
    ToolbarItem(placement: .primaryAction) {
        Button(action: { showOpacityPopover = true }) {
            HStack(spacing: 4) {
                Image(systemName: opacityIcon(for: settings.windowOpacity))
                Text("\(Int(settings.windowOpacity * 100))%")
                    .font(.caption).monospacedDigit()
            }
        }
        .popover(isPresented: $showOpacityPopover, arrowEdge: .bottom) {
            OpacityPopoverContent(opacity: $settings.windowOpacity)
        }
        .help("Window opacity")
    }

    // Pin toggle
    ToolbarItem(placement: .primaryAction) {
        Toggle(isOn: $settings.windowPinned) {
            Image(systemName: "pin")
        }
        .toggleStyle(.button)
        .help("Pin window (⌘P)")
        .keyboardShortcut("p", modifiers: .command)
    }
}
```
