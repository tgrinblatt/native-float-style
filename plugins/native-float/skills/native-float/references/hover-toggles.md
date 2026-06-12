# HoverToggles Cluster

The HoverToggles cluster is one of two identity marks in Native Float. It provides quick access to window-level controls: magnet (follow across desktops), appearance, opacity, and pin/float. The cluster is collapsible — a small close toggle shrinks it to [open-chevron + a still-functional pin] when the user wants the toolbar quiet.

> **Standard v3 (2026-06-12).** Source of truth: the Kaddy app (beta-v0.1.2), Tyler's
> `HoverToggles-Update.pdf` redesign. v2's ARCHITECTURE stands unchanged — ONE cohesive HStack in
> ONE ToolbarItem (the v1 "three separate items" rule remains dead; NSToolbar tears separate items
> and even `ControlGroup`s apart). What v3 changes is the arrangement and the state language:
> - **Order:** magnet · appearance · opacity (a TIGHT 2pt trio) · close › · pin — the close
>   control sits beside the pin so collapse/expand stays in the same mouse area.
> - **Collapsed form:** [‹ open chevron · FUNCTIONAL always-circled pin] — the pin is the
>   most-used toggle, so it stays one click (and ⌘P) away even collapsed. The old passive
>   app-symbol chip is retired; the collapsed cluster takes zero ghost room.
> - **Magnet active state:** a smaller translucent YELLOW halo with the glyph in the ACCENT
>   color — visually distinct from the pin's solid accent circle (they read too similar in v2).
> - **Color discipline:** `.tint` everywhere (never `Color.accentColor` — it ignores runtime
>   tint) and ABSOLUTE `Color.secondary` for neutral glyphs (hierarchical `.secondary` resolves
>   against the toolbar button's tinted base = transparent-accent icons).

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
| Rhythm cell (every control's outer footprint) | 30×30pt |
| Cluster HStack spacing | 4pt |
| Tight-trio spacing (magnet · appearance · opacity) | 2pt |
| Pin on-state accent circle | 30pt → 3pt breathing room from the glass |
| Magnet active halo (yellow) | 24pt, inside its 30pt cell |
| Close toggle's persistent grey circle | 20pt, inside its 30pt cell |
| Leading padding (first control) | 4pt |
| Trailing padding (last control) | 4pt (the capsule hugs content) |
| Collapsed: chevron leading padding | 8pt |

**The footprint rule:** every control in the cluster is a borderless button whose OUTER frame is the 30×30 rhythm cell. A default-styled toolbar button must never sit inside the cluster — the system inflates it to 36×36 and breaks the rhythm.

**The rhythm-cell pattern (new in v3):** controls whose visible state is SMALLER than 30pt (the 24pt magnet halo, the 20pt close circle) draw the visual at its own size, then wrap it in a second 30×30 frame. The inner frame sizes the look; the outer frame keeps the cluster's spacing math uniform:

```swift
Image(...)
    .frame(width: 24, height: 24)                 // the visual (halo) size
    .background(Circle().fill(...))
    .frame(width: 30, height: 30)                 // the rhythm cell
    .contentShape(Circle())
```

## The Dials

Every v3 tunable lives in one enum so taste adjustments are one-number edits:

```swift
enum HoverToggleMetrics {
    /// The magnet's active halo: smaller than the pin's 30pt accent circle
    /// so magnet/appearance/opacity read as a tight group.
    static let magnetHaloDiameter: CGFloat = 24
    /// Translucent yellow (#FFD524-family) — deliberately NOT the accent.
    static let magnetHaloColor = Color(red: 1.0, green: 0xD5 / 255.0, blue: 0x24 / 255.0)
    static let magnetHaloOpacity = 0.85
    /// The close (collapse) toggle's persistent grey circle — smaller again.
    static let closeHaloDiameter: CGFloat = 20
    static let closeHaloOpacity = 0.12
    /// Spacing inside the tight magnet/appearance/opacity group.
    static let tightSpacing: CGFloat = 2
    /// The collapsed pin's persistent circle when NOT pinned.
    static let collapsedPinGreyOpacity = 0.16
}
```

## The Cluster

```swift
struct HoverTogglesCluster: View {
    @Bindable var settings: AppSettings

    var body: some View {
        HStack(spacing: 4) {
            if settings.hoverTogglesCollapsed {
                // Open chevron — NO highlight, pointing left: the direction
                // the cluster grows back.
                Button {
                    setCollapsed(false)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                        .padding(.leading, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.borderless)
                .help("Show window controls")

                // The FUNCTIONAL collapsed pin: persistent circle, accent
                // when active, grey when not — one-click pinning while
                // collapsed (pin is the most-used toggle).
                CollapsedPinToggle(settings: settings)
                    .padding(.trailing, 4)
            } else {
                // The tight trio: magnet · appearance · opacity.
                HStack(spacing: HoverToggleMetrics.tightSpacing) {
                    MagnetToggle(settings: settings)
                        .padding(.leading, 4)
                    AppearanceToggle(settings: settings)
                    OpacityToggle(settings: settings)
                }

                // Close (collapse) toggle: small persistent grey circle,
                // chevron pointing right — the direction it shrinks. Sits
                // BESIDE the pin so collapsing barely moves the mouse target.
                Button {
                    setCollapsed(true)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.secondary)
                        .frame(width: HoverToggleMetrics.closeHaloDiameter,
                               height: HoverToggleMetrics.closeHaloDiameter)
                        .background(
                            Circle().fill(Color.secondary.opacity(
                                HoverToggleMetrics.closeHaloOpacity))
                        )
                        // Keep the 30pt rhythm cell so neighbors don't crowd.
                        .frame(width: HoverToggleStyle.circleDiameter,
                               height: HoverToggleStyle.circleDiameter)
                        .contentShape(Circle())
                }
                .buttonStyle(.borderless)
                .help("Collapse window controls")

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
- **The collapse flip is TOOLBAR PRESSURE:** expanding/collapsing adds/removes ~90pt of toolbar
  content with NO window resize. If the window has any toolbar fit/overflow machinery, the
  collapsed flag must be wired into it as an input so the flip triggers a fit pass (proven in
  Kaddy: without it, the native ≫ overflow chevron appeared silently).

## HoverToggleStyle

On-state toggles (pin) render an explicit 30pt accent circle. The system `.toggleStyle(.button)` draws its highlight full-bleed (36pt, touching the glass) — don't use it here.

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
                // ABSOLUTE Color.secondary, not hierarchical .secondary:
                // toolbar buttons set a tinted base style and hierarchical
                // styles derive from it (= transparent-accent icons).
                .foregroundStyle(configuration.isOn
                                 ? AnyShapeStyle(.white)
                                 : AnyShapeStyle(Color.secondary))
                .frame(width: Self.circleDiameter, height: Self.circleDiameter)
                .background(
                    Circle().fill(configuration.isOn
                                  ? AnyShapeStyle(.tint)        // never Color.accentColor
                                  : AnyShapeStyle(Color.clear))
                )
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
    }
}
```

## The Controls

### Magnet Toggle (tight trio, position 1)

Follow-across-desktops control: on = the window joins all Spaces (it follows the user from desktop to desktop), off = it stays home. There is no magnet SF Symbol — the glyph ships as a generated-Path template `NSImage`.

**v3 active state:** a smaller translucent YELLOW halo (`HoverToggleMetrics.magnetHalo*`) with the glyph in the ACCENT color — instantly distinguishable from the pin's solid accent circle. The accent-colored glyph is a DELIBERATE exception to the accent-scope rule (accent = fills/highlights only, never glyphs) — the one "this thing is live" semantic. Inactive = plain icon, no highlight.

```swift
struct MagnetToggle: View {
    @Bindable var settings: AppSettings

    private var isOn: Bool { settings.showOnAllDesktops }

    var body: some View {
        Button {
            settings.showOnAllDesktops.toggle()
        } label: {
            Image(nsImage: MagnetIcon.templateImage(active: isOn))
                .foregroundStyle(isOn
                                 ? AnyShapeStyle(.tint)
                                 : AnyShapeStyle(Color.secondary))
                .frame(width: HoverToggleMetrics.magnetHaloDiameter,
                       height: HoverToggleMetrics.magnetHaloDiameter)
                .background(
                    Circle().fill(isOn
                                  ? AnyShapeStyle(
                                      HoverToggleMetrics.magnetHaloColor
                                          .opacity(HoverToggleMetrics.magnetHaloOpacity))
                                  : AnyShapeStyle(Color.clear))
                )
                // Keep the cluster's 30pt rhythm cell around the smaller halo.
                .frame(width: HoverToggleStyle.circleDiameter,
                       height: HoverToggleStyle.circleDiameter)
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
        .help(isOn
              ? "Send back to its own desktop"
              : "Follow you from desktop to desktop")
    }
}
```

### Appearance Toggle (tight trio, position 2)

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
                .foregroundStyle(Color.secondary)
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

### Opacity Control (tight trio, position 3)

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
                .foregroundStyle(Color.secondary)
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

Popover content: header row (`Label("Transparency", systemImage:)` + monospaced percentage readout), slider (0.25…1.0, step 0.05, `.controlSize(.small)`), then preset chips `[0.25, 0.35, 0.50, 0.70, 0.85, 1.00]` — active chip gets `.tint.opacity(0.25)` fill + `0.6` stroke, inactive `secondary.opacity(0.12)`.

### Pin Toggle (trailing, after the close toggle)

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

### Collapsed Pin (the collapsed form's second control)

Unlike the expanded PinToggle (circle only when active), the collapsed pin ALWAYS wears a circle — accent when pinned, grey when not — so the collapsed capsule reads as [chevron · button]. The keyboard shortcut stays live in both forms.

```swift
struct CollapsedPinToggle: View {
    @Bindable var settings: AppSettings

    var body: some View {
        Button {
            settings.windowPinned.toggle()
        } label: {
            Image(systemName: settings.windowPinned ? "pin.fill" : "pin")
                .foregroundStyle(settings.windowPinned
                                 ? AnyShapeStyle(.white)
                                 : AnyShapeStyle(Color.secondary))
                .frame(width: HoverToggleStyle.circleDiameter,
                       height: HoverToggleStyle.circleDiameter)
                .background(
                    Circle().fill(settings.windowPinned
                                  ? AnyShapeStyle(.tint)
                                  : AnyShapeStyle(Color.secondary.opacity(
                                      HoverToggleMetrics.collapsedPinGreyOpacity)))
                )
                .contentShape(Circle())
        }
        .buttonStyle(.borderless)
        .keyboardShortcut("p", modifiers: [.command])
        .help(settings.windowPinned
              ? "Stop floating above other apps (⌘P)"
              : "Float above other apps (⌘P)")
    }
}
```

## WindowAccessor Connection

Unchanged in mechanism: the toggles write `AppSettings` properties; `WindowAccessor` (`.background(...)` on the root view, primitives only) applies them to the NSWindow:

```swift
.background(WindowAccessor(
    isPinned: settings.windowPinned,               // → window.level (.floating / .normal)
    opacity: settings.windowOpacity,               // → window.backgroundColor alpha
    showOnAllDesktops: settings.showOnAllDesktops, // → collectionBehavior (joins all Spaces)
    hoverTogglesCollapsed: settings.hoverTogglesCollapsed  // → toolbar-pressure input (see note)
))
```

The appearance toggle drives `.preferredColorScheme(...)`.

## Rules

- ONE ToolbarItem, ONE HStack — never separate items, never `ToolbarItemGroup`, never `ControlGroup`.
- Order: magnet · appearance · opacity (tight, 2pt) · close › · pin. Collapsed: ‹ open · functional pin.
- Uniform 30×30 rhythm cells; smaller visuals (24pt magnet halo, 20pt close circle) sit centered INSIDE their cell via the double-frame pattern; nothing default-styled inside the cluster.
- Pin on-state = `HoverToggleStyle`'s 30pt accent circle; magnet on-state = the 24pt yellow halo + accent glyph (the one deliberate accent-glyph exception); never the full-bleed `.toggleStyle(.button)`.
- `.tint` for accent fills — never `Color.accentColor` (ignores runtime tint). Neutral glyphs use ABSOLUTE `Color.primary`/`Color.secondary` — never hierarchical styles inside toolbar buttons.
- Custom glyphs are template `NSImage`s, never `Shape` views (a Shape label splits out of the shared glass capsule).
- In customizable toolbars: lock with `.customizationBehavior(.disabled)`; never mix plain `.toolbar {}` items into the window.
- Collapsed state persists; transitions are springs; the collapse flip must feed any toolbar fit machinery as a pressure input.
