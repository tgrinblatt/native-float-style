# HoverToggles Cluster

The HoverToggles cluster is one of two identity marks in Native Float. It provides quick access to window-level controls: appearance, opacity, magnet (follow across desktops), and pin/float. The cluster is collapsible — a chevron shrinks it to a single symbol when the user wants the toolbar quiet.

> **Standard v2 (2026-06).** This REVERSES the original rule ("three separate `ToolbarItem(.primaryAction)`s, never combine"). Production use in KeyDeck (beta-v0.0.6) proved the old pattern breaks on macOS 26: NSToolbar's layout distributes separate items — and even a `ControlGroup` — apart across the trailing region, tearing the cluster to pieces. The auto-grouping the old rule relied on is not dependable once a window has a customizable toolbar. One cohesive HStack in ONE item survives every layout.

## Architecture

ONE `ToolbarItem` whose content is a single HStack (`HoverTogglesCluster`). The system wraps the whole thing in one glass capsule and can never distribute its controls apart.

```swift
ToolbarItem(id: "hoverToggles", placement: .primaryAction) {
    HoverTogglesCluster(settings: settings)
}
.customizationBehavior(.disabled)   // locked: always present, pinned trailing
```

In a customizable toolbar (`.toolbar(id:)`), the cluster is a LOCKED item via `.customizationBehavior(.disabled)` — never a plain `.toolbar {}` item: on macOS 26 a single plain fixed item anywhere in the window disables Customize Toolbar… window-wide.

## Geometry (probe-measured, not eyeballed)

The toolbar gives a default-styled button **36×36pt** — that is the glass capsule's interior height, and it is also why naive clusters look uneven: default buttons inflate to 36 while explicitly framed controls don't, producing mixed icon rhythms.

| Metric | Value |
|--------|-------|
| Capsule interior (system control size) | 36pt |
| Control footprint (every control, uniform) | 30×30pt |
| HStack spacing | 4pt |
| Resulting icon center-to-center rhythm | 34pt, uniform |
| On-state accent circle | 30pt → 3pt breathing room from the glass |
| Collapse chevron leading padding | 8pt |
| Last control trailing padding | 4pt (the capsule hugs content) |
| Collapsed capsule height | 24pt |

**The footprint rule:** every control in the cluster is a borderless button whose label is framed to 30×30. A default-styled toolbar button must never sit inside the cluster — the system inflates it to 36×36 and breaks the rhythm.

## The Cluster

```swift
struct HoverTogglesCluster: View {
    @Bindable var settings: AppSettings

    var body: some View {
        HStack(spacing: 4) {
            if settings.hoverTogglesCollapsed {
                // Expand control: chevron + the app's cluster symbol in ONE
                // grey capsule, so it reads as a single uniform piece.
                Button {
                    setCollapsed(false)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Image(nsImage: ClusterSymbol.templateImage())
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 24)
                    .background(Capsule().fill(Color.secondary.opacity(0.12)))
                }
                .buttonStyle(.borderless)
                .help("Show window controls")
            } else {
                // Collapse arrow on the LEFT, pointing right — the
                // direction the cluster shrinks.
                Button {
                    setCollapsed(true)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.leading, 8)
                }
                .buttonStyle(.borderless)
                .help("Collapse window controls")

                AppearanceToggle(settings: settings)
                OpacityToggle(settings: settings)
                MagnetToggle(settings: settings)
                PinToggle(settings: settings)
                    .padding(.trailing, 4)
            }
        }
        .labelStyle(.iconOnly)
        .animation(Motion.selection, value: settings.hoverTogglesCollapsed)
    }

    private func setCollapsed(_ collapsed: Bool) {
        withAnimation(Motion.selection) {
            settings.hoverTogglesCollapsed = collapsed
        }
    }
}
```

Implementation notes:
- `hoverTogglesCollapsed` persists in UserDefaults like every other window setting.
- Springs only (`Motion.selection`), per the system-wide animation rule.
- The collapsed symbol is app-specific (KeyDeck uses a stacked-cards glyph). Ship it as a cached **template `NSImage`** (`isTemplate = true`) — never a custom `Shape` view: a Shape label splits out of the shared glass capsule.

## HoverToggleStyle

On-state toggles (magnet, pin) render an explicit 30pt accent circle. The system `.toggleStyle(.button)` draws its highlight full-bleed (36pt, touching the glass) — don't use it here.

```swift
struct HoverToggleStyle: ToggleStyle {
    /// 3pt of breathing room between the circle and the capsule edge.
    static let circleDiameter: CGFloat = 30

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .labelStyle(.iconOnly)
                .foregroundStyle(configuration.isOn
                                 ? AnyShapeStyle(.white)
                                 : AnyShapeStyle(.secondary))
                .frame(width: Self.circleDiameter, height: Self.circleDiameter)
                .background(
                    Circle().fill(configuration.isOn ? Color.accentColor : .clear)
                )
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
    }
}
```

## The Four Controls

### Appearance Toggle

Binary light/dark switch. Filled icon reflects the **current** state.

```swift
struct AppearanceToggle: View {
    @Bindable var settings: AppSettings
    private var isLight: Bool { settings.appearance == "light" }

    var body: some View {
        Button {
            settings.toggleAppearance()
        } label: {
            Image(systemName: isLight ? "sun.max.fill" : "moon.fill")
                .foregroundStyle(.secondary)
                .frame(width: HoverToggleStyle.circleDiameter,
                       height: HoverToggleStyle.circleDiameter)
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
        .help(isLight ? "Switch to Dark mode (⇧⌘D)" : "Switch to Light mode (⇧⌘D)")
        .keyboardShortcut("d", modifiers: [.command, .shift])
    }
}
```

### Opacity Control

Icon-only button (the percentage lives in the popover, not the toolbar). Opens a popover with a labeled slider and preset chips.

```swift
struct OpacityToggle: View {
    @Bindable var settings: AppSettings
    @State private var showPopover = false

    var body: some View {
        Button {
            showPopover.toggle()
        } label: {
            Image(systemName: opacityIcon)
                .foregroundStyle(.secondary)
                .frame(width: HoverToggleStyle.circleDiameter,
                       height: HoverToggleStyle.circleDiameter)
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
        .help("Window transparency")
        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
            OpacityPopover(settings: settings)
                .frame(width: 260)
                .padding(14)
        }
    }

    private var opacityIcon: String {
        if settings.windowOpacity >= 0.95 { return "circle.fill" }
        if settings.windowOpacity >= 0.6 { return "circle.lefthalf.filled" }
        return "circle.dotted"
    }
}
```

Popover content: header row (`Label("Transparency", systemImage:)` + monospaced percentage readout), slider (0.25…1.0, step 0.05, `.controlSize(.small)`), then preset chips `[0.25, 0.35, 0.50, 0.70, 0.85, 1.00]` — active chip gets `accentColor.opacity(0.25)` fill + `0.6` stroke, inactive `secondary.opacity(0.12)`.

### Magnet Toggle

Follow-across-desktops control: on = the window joins all Spaces (it follows the user from desktop to desktop), off = it stays home. There is no magnet SF Symbol — the glyph ships as a generated-Path template `NSImage`.

```swift
struct MagnetToggle: View {
    @Bindable var settings: AppSettings

    var body: some View {
        Toggle(isOn: $settings.showOnAllDesktops) {
            Label {
                Text(settings.showOnAllDesktops
                     ? "Stop following desktops"
                     : "Follow across desktops")
            } icon: {
                Image(nsImage: MagnetIcon.templateImage(
                    active: settings.showOnAllDesktops
                ))
            }
        }
        .toggleStyle(HoverToggleStyle())
        .help(settings.showOnAllDesktops
              ? "Send back to its own desktop"
              : "Follow you from desktop to desktop")
    }
}
```

### Pin Toggle

```swift
struct PinToggle: View {
    @Bindable var settings: AppSettings

    var body: some View {
        Toggle(isOn: $settings.windowPinned) {
            Label(
                settings.windowPinned ? "Unpin window" : "Pin window above others",
                systemImage: settings.windowPinned ? "pin.fill" : "pin"
            )
        }
        .toggleStyle(HoverToggleStyle())
        .keyboardShortcut("p", modifiers: [.command])
        .help(settings.windowPinned
              ? "Stop floating above other apps (⌘P)"
              : "Float above other apps (⌘P)")
    }
}
```

## WindowAccessor Connection

Unchanged from v1: the toggles write `AppSettings` properties; `WindowAccessor` (`.background(...)` on the root view, primitives only) applies them to the NSWindow:

```swift
.background(WindowAccessor(
    isPinned: settings.windowPinned,               // → window.level (.floating / .normal)
    opacity: settings.windowOpacity,               // → window.backgroundColor alpha
    showOnAllDesktops: settings.showOnAllDesktops  // → collectionBehavior (.canJoinAllSpaces / [])
))
```

The appearance toggle drives `.preferredColorScheme(...)`.

## Rules

- ONE ToolbarItem, ONE HStack — never separate items, never `ToolbarItemGroup`, never `ControlGroup`.
- Uniform 30×30 borderless footprints; 4pt spacing; nothing default-styled inside the cluster.
- On-state = `HoverToggleStyle`'s 30pt accent circle, never the full-bleed `.toggleStyle(.button)`.
- Custom glyphs are template `NSImage`s, never `Shape` views.
- In customizable toolbars: lock with `.customizationBehavior(.disabled)`; never mix plain `.toolbar {}` items into the window.
- Collapsed state persists; transitions are springs.
