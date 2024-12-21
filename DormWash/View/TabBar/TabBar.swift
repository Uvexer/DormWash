import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Spacer()
            TabBarButton(imageName: "washer", isSelected: selectedTab == 0) {
                withAnimation(.easeInOut) {
                    selectedTab = 0
                }
            }
            Spacer()
            TabBarButton(imageName: "star", isSelected: selectedTab == 1) {
                withAnimation(.easeInOut) {
                    selectedTab = 1
                }
            }
            Spacer()
            TabBarButton(imageName: "gear", isSelected: selectedTab == 2) {
                withAnimation(.easeInOut) {
                    selectedTab = 2
                }
            }
            Spacer()
        }
        .frame(width: 250, height: 60)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
