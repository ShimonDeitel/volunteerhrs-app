import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accentGradient)
                Text("Volunteerhrs Pro")
                    .font(Theme.titleFont)
                Text("Exportable signed hour report")
                    .font(Theme.bodyFont)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                Text("One-time purchase")
                    .font(Theme.captionFont)
                    .foregroundStyle(.secondary)
                Button {
                    Task {
                        await purchases.purchase()
                        dismiss()
                    }
                } label: {
                    Text("Unlock Pro")
                        .font(Theme.headlineFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accentGradient)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("paywallUnlockButton")
                .padding(.horizontal)

                Button("Not Now") {
                    dismiss()
                }
                .accessibilityIdentifier("paywallDismissButton")
            }
            .padding()
            .navigationTitle("Go Pro")
        }
    }
}
