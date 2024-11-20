import SwiftUI

struct SpinningDrumView: View {
    @State private var isRotating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(Color.red.opacity(0.7))
                    .frame(width: 5, height: 15)
                    .offset(y: -20)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
        }
        .rotationEffect(.degrees(isRotating ? 360 : 0))
        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isRotating)
        .onAppear {
            isRotating = true
        }
    }
}

