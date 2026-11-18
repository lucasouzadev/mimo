import SwiftUI

/// Medidas em pontos, tiradas das gravações de referência.
public enum MimoMetrics {
    public static let screenPadding: CGFloat = 24
    public static let gridSpacing: CGFloat = 10

    public static let imageRadius: CGFloat = 16
    public static let cardRadius: CGFloat = 30
    public static let alertRadius: CGFloat = 32

    public static let buttonHeight: CGFloat = 54
    public static let buttonRadius: CGFloat = 20
    public static let fieldHeight: CGFloat = 52
    public static let chipHeight: CGFloat = 40
    public static let pillHeight: CGFloat = 36
    public static let circleButton: CGFloat = 44

    public static let tabBarHeight: CGFloat = 54
    public static let alertWidth: CGFloat = 296
}

public extension View {
    /// Sombra única do Mimo. Use só em superfícies brancas.
    func mimoShadow() -> some View {
        shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}
