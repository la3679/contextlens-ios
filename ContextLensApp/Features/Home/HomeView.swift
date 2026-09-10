import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Label("PRIVATE BY DEFAULT", systemImage: "lock.shield")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text("Your context.\nMade clear.")
                    .font(.largeTitle.bold())
                    .accessibilityIdentifier("home.headline")
                Text("A thoughtful space for the information you want to understand and keep.")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Built around your context")
                        .font(.headline)
                    feature("Text & notes", symbol: "text.alignleft", detail: "Bring your thoughts together.")
                    feature("Images & documents", symbol: "doc.viewfinder", detail: "Keep the important details in view.")
                    feature("A personal library", symbol: "square.stack.3d.up", detail: "Return to what matters.")
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.background, in: RoundedRectangle(cornerRadius: 20))

                Label("Cloud processing is off", systemImage: "iphone")
                    .font(.subheadline)
                    .accessibilityIdentifier("home.privacy")
            }
            .padding(24)
            .frame(maxWidth: 640, alignment: .leading)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("ContextLens")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func feature(_ title: String, symbol: String, detail: String) -> some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: symbol).foregroundStyle(.tint)
        }
        .accessibilityElement(children: .combine)
    }
}
