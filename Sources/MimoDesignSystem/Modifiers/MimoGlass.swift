import SwiftUI

public extension View {
    /// Vidro do Mimo. No iOS 26+ usa o Liquid Glass do sistema;
    /// no iOS 18 cai para material translúcido com borda fina.
    ///
    /// É o único lugar do app que checa a versão do iOS para vidro:
    /// nenhuma tela deve usar `glassEffect` diretamente.
    @ViewBuilder
    func mimoGlass<S: Shape>(in shape: S, interactive: Bool = false) -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(interactive ? .regular.interactive() : .regular, in: shape)
        } else {
            self
                .background(.ultraThinMaterial, in: shape)
                .overlay(shape.stroke(Color.white.opacity(0.55), lineWidth: 0.5))
                .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
        }
    }
}
