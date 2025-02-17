import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var animationNamespace
    private let buttonWidth: CGFloat = 70
    private let buttonHeight: CGFloat = 50

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.blue)
                .padding(3)
                .frame(width: buttonWidth, height: buttonHeight)
                .offset(x: CGFloat(selectedTab) * buttonWidth, y: 0)
                .animation(.easeInOut(duration: 0.3), value: selectedTab)

            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabBarButton(
                        imageName: tab.imageName,
                        isSelected: selectedTab == tab.rawValue,
                        animationNamespace: animationNamespace
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab.rawValue
                        }
                    }
                    .frame(width: buttonWidth, height: buttonHeight)
                }
            }
        }
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)
        )
        .frame(width: buttonWidth * CGFloat(Tab.allCases.count), height: buttonHeight)
    }
}
