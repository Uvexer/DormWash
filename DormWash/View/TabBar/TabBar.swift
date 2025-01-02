import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                TabBarButton(imageName: tab.imageName, isSelected: selectedTab == tab.rawValue) {
                    selectedTab = tab.rawValue
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
