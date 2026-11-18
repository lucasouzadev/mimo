import SwiftUI

/// Paleta do Mimo. Valores amostrados das gravações de referência;
/// ajuste a olho no aparelho, mantendo os papéis.
public enum MimoColor {
    // Fundo
    public static let backgroundTop = Color(hex: 0xEFE6D4)
    public static let backgroundBottom = Color(hex: 0xF0DCB8)
    public static let backgroundGlow = Color(hex: 0xF6D99E)

    // Superfícies
    /// Branco quente: cartões de ação, campos, botão primário, alertas.
    public static let surface = Color(hex: 0xFDFBF9)
    /// Bege um tom acima do fundo: botão secundário, chips, campos opcionais.
    public static let fill = Color(hex: 0xE9DFC9)
    /// Bege mais escuro: item ativo em segmentos e chips de valor.
    public static let fillStrong = Color(hex: 0xDDD2BA)

    // Texto
    public static let textPrimary = Color(hex: 0x1A1512)
    public static let textSecondary = Color(hex: 0x8A8070)

    // Semânticas
    /// Única cor de marca: ação e progresso.
    public static let accent = Color(hex: 0x0A48F8)
    public static let destructive = Color(hex: 0xF82830)
    public static let success = Color(hex: 0x2F9E52)

    // Tela de presente recebido
    public static let darkBackground = Color(hex: 0x191718)
    public static let darkSurface = Color(hex: 0x282322)
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
