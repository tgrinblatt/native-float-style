# Component Patterns

## SettingsCard

Reusable container for settings sections. Used when rendering in-canvas settings.

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

## Search Field (Capsule)

```swift
struct SidebarSearchField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.subheadline)

            TextField("Search", text: $text)
                .textFieldStyle(.plain)
                .font(.subheadline)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color(nsColor: .separatorColor), lineWidth: 0.5))
    }
}
```

## Card View

```swift
struct DemoCard: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
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
        .scaleEffect(isSelected ? 1.03 : 1.0)
        .shadow(color: .black.opacity(isSelected ? 0.30 : 0), radius: isSelected ? 6 : 0, y: isSelected ? 2 : 0)
        .shadow(color: .black.opacity(isSelected ? 0.40 : 0), radius: isSelected ? 22 : 0, y: isSelected ? 12 : 0)
        .overlay(
            Group {
                if isSelected && colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.white.opacity(0.45), lineWidth: 1)
                }
            }
        )
        .animation(NativeFloatTokens.Motion.selection, value: isSelected)
        .contentShape(Rectangle())
    }
}
```

## Drag Preview Capsule

```swift
struct DragPreviewCapsule: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.regularMaterial, in: Capsule())
            .overlay(Capsule().stroke(Color(nsColor: .separatorColor), lineWidth: 0.5))
    }
}
```

## Context Menu Pattern

```swift
.contextMenu {
    Button("Open") { open(item) }
    Button("Rename") { startRename(item) }

    Divider()

    Menu("Move to") {
        ForEach(folders) { folder in
            Button(folder.name) { move(item, to: folder) }
        }
    }

    Divider()

    Button("Delete", role: .destructive) { delete(item) }
}
```

## Confirmation Dialog Pattern

```swift
.confirmationDialog(
    "Clear all items?",
    isPresented: $showClearConfirmation,
    titleVisibility: .visible
) {
    Button("Clear All", role: .destructive) {
        clearAll()
    }
    Button("Cancel", role: .cancel) { }
} message: {
    Text("This action cannot be undone.")
}
```

## Toggle in Settings

```swift
SettingsCard(title: "Behavior") {
    Toggle("Pin window on launch", isOn: $settings.pinOnLaunch)
    Toggle("Show on all desktops", isOn: $settings.showOnAllDesktops)
    Toggle("Hide on close (⌘W)", isOn: $settings.hideOnClose)
}
```

## Popover (Opacity Control)

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
