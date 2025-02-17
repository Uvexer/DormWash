import SwiftUI

struct TabBarButton: View {
    let imageName: String
    let isSelected: Bool
    let animationNamespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.title3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(isSelected ? .white : .gray)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
