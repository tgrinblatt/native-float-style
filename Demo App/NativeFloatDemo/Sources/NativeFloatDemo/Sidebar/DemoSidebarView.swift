import SwiftUI

struct DemoSidebarView: View {
    @Binding var selection: Showcase?
    @State private var searchText = ""

    private var filteredShowcases: [Showcase] {
        if searchText.isEmpty { return Showcase.allCases }
        return Showcase.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Native Float")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { selection = .settings }) {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            SidebarSearchField(text: $searchText)
                .padding(.horizontal, 12)
                .padding(.top, 12)

            Divider()
                .padding(.top, 12)

            List(selection: $selection) {
                ForEach(ShowcaseSection.allCases, id: \.self) { section in
                    let items = filteredShowcases.filter { $0.section == section }
                    if !items.isEmpty {
                        Section(section.rawValue) {
                            ForEach(items) { showcase in
                                Label(showcase.rawValue, systemImage: showcase.icon)
                                    .tag(showcase)
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}
