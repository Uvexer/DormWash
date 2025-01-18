import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 30) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabBarButton(imageName: tab.imageName, isSelected: selectedTab == tab.rawValue) {
                    selectedTab = tab.rawValue
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: 217, minHeight: 45)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)
        )
    }
}
