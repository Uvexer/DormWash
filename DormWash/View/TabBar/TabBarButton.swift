import SwiftUI

struct TabBarButton: View {
    let imageName: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: imageName)
                    .font(.system(size: 24))
            }
            .padding()
            .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}
