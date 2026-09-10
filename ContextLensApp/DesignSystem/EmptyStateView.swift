import SwiftUI

struct EmptyStateView: View {
    let title: String
    let symbol: String
    let message: String
    let identifier: String

    var body: some View {
        ScrollView {
            ContentUnavailableView(title, systemImage: symbol, description: Text(message))
                .padding(.top, 48)
                .accessibilityIdentifier(identifier)
        }
    }
}
