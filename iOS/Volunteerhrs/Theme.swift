import SwiftUI

/// Unique theme for Volunteerhrs: warm generous green.
enum Theme {
    static let accent = Color(red: 0.1176, green: 0.5490, blue: 0.4275)
    static let accentDark = Color(red: 0.0000, green: 0.3922, blue: 0.2706)
    static let background = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)

    static let titleFont: Font = .system(.title2, design: .rounded).weight(.bold)
    static let headlineFont: Font = .system(.headline, design: .rounded)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .rounded)

    static var accentGradient: LinearGradient {
        LinearGradient(colors: [accent, accentDark], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
