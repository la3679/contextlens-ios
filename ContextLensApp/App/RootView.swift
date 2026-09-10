import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "viewfinder") }
            NavigationStack {
                EmptyStateView(
                    title: "A place for useful context",
                    symbol: "square.stack.3d.up",
                    message: "Your saved analyses will appear here, ready to revisit.",
                    identifier: "library.empty"
                )
                .navigationTitle("Library")
            }
            .tabItem { Label("Library", systemImage: "square.stack.3d.up") }
            NavigationStack {
                EmptyStateView(
                    title: "Find the things that matter",
                    symbol: "magnifyingglass",
                    message: "Once you have saved context, search will help you find it again.",
                    identifier: "search.empty"
                )
                .navigationTitle("Search")
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            NavigationStack { SettingsView() }
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .tint(.accentColor)
    }
}
