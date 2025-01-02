import StoreKit
import SwiftUI

struct RateAppButton: View {
    var body: some View {
        Button(action: {
            requestAppReview()
        }) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Оценить приложение")
            }
            .foregroundColor(.white)
        }
        .listRowBackground(Color.clear)
    }

    private func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
