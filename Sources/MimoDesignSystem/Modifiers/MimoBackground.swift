import SwiftUI

/// Fundo creme contínuo: degradê vertical + brilho amarelado no terço inferior.
public struct MimoBackground: View {
    public init() {}

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [MimoColor.backgroundTop, MimoColor.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            RadialGradient(
                colors: [MimoColor.backgroundGlow.opacity(0.55), .clear],
                center: UnitPoint(x: 0.5, y: 0.8),
                startRadius: 0,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}

/// Fundo escuro com brilho sutil, usado só na tela de presente recebido.
public struct MimoDarkBackground: View {
    public init() {}

    public var body: some View {
        ZStack {
            MimoColor.darkBackground
            RadialGradient(
                colors: [Color.white.opacity(0.06), .clear],
                center: UnitPoint(x: 0.5, y: 0.3),
                startRadius: 0,
                endRadius: 380
            )
        }
        .ignoresSafeArea()
    }
}

public extension View {
    func mimoBackground() -> some View {
        background { MimoBackground() }
    }

    func mimoDarkBackground() -> some View {
        background { MimoDarkBackground() }
            .preferredColorScheme(.dark)
    }
}
