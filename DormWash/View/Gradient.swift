import SwiftUI

struct AnimatedGradientBackground: ViewModifier {
    @State private var animateGradient: Bool = false
    private let startColor: Color = .blue
    private let endColor: Color = .green
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                    .hueRotation(.degrees(animateGradient ? 45 : 0))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }
            )
    }
}
extension View {
    func animatedGradientBackground() -> some View {
        self.modifier(AnimatedGradientBackground())
    }
}
