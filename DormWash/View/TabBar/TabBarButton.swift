import SwiftUI

struct TabBarButton: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void
    @Namespace private var animationNamespace

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.title3)
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected ? .white : .gray)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.clear)
                        .frame(width: 70, height: 39)
                        .matchedGeometryEffect(id: imageName, in: animationNamespace)
                )
                .contentShape(Capsule())
                .animation(.easeInOut(duration: 0.01), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}
