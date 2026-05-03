import SwiftUI

struct AnimationShowcase: View {
    @State private var selectionAnimating = false
    @State private var layoutAnimating = false
    @State private var itemVisible = true
    @State private var scaleActive = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.xl) {
                Text("Animation")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Two springs. That's the entire motion system.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SELECTION SPRING")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "response: 0.28, dampingFraction: 0.7") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Fast, snappy. Used for: card selection, toggle states, button feedback.")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button("Trigger") {
                                withAnimation(NativeFloatTokens.Motion.selection) {
                                    selectionAnimating.toggle()
                                }
                            }

                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.accentColor)
                                .frame(width: 60, height: 60)
                                .offset(x: selectionAnimating ? 200 : 0)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("LAYOUT SPRING")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "response: 0.35, dampingFraction: 0.75") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Smooth, gentle. Used for: layout changes, sidebar, view transitions.")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button("Trigger") {
                                withAnimation(NativeFloatTokens.Motion.layout) {
                                    layoutAnimating.toggle()
                                }
                            }

                            HStack(spacing: layoutAnimating ? 24 : 8) {
                                ForEach(0..<4) { i in
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(Color.accentColor.opacity(Double(i + 1) / 4.0))
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("TRANSITIONS")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Insert: .scale(0.85) + .opacity | Remove: .opacity") {
                        VStack(alignment: .leading, spacing: 12) {
                            Button(itemVisible ? "Remove" : "Add") {
                                withAnimation(NativeFloatTokens.Motion.layout) {
                                    itemVisible.toggle()
                                }
                            }

                            if itemVisible {
                                DemoCard(title: "Appearing Item", subtitle: "Scale + opacity on insert")
                                    .frame(maxWidth: 200)
                                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: NativeFloatTokens.Spacing.lg) {
                    Text("SCALE EFFECT")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    SettingsCard(title: "Selection: scaleEffect(1.03)") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Subtle lift, no reflow. Uses scaleEffect not frame change.")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button(scaleActive ? "Deselect" : "Select") {
                                scaleActive.toggle()
                            }

                            DemoCard(
                                title: "Scalable Card",
                                subtitle: "Click the button above to toggle selection state",
                                isSelected: scaleActive
                            )
                            .frame(maxWidth: 250)
                        }
                    }
                }
            }
            .padding(NativeFloatTokens.Spacing.xl)
        }
        .scrollIndicators(.hidden)
    }
}
