import SwiftUI

/// Botão largo de 54 pt. Branco significa "toque aqui".
public struct MimoButtonStyle: ButtonStyle {
    public enum Kind: Sendable {
        /// Fundo branco, texto azul. CTA principal ("Adicionar à lista").
        case primary
        /// Fundo branco, texto escuro. Confirmação em alertas.
        case neutral
        /// Fundo bege, texto escuro. Ação secundária, "Cancelar".
        case secondary
        /// Bege esverdeado com texto verde. Etapa concluída.
        case success
        /// Superfície escura, texto branco. Tela de presente recebido.
        case dark
    }

    let kind: Kind

    public init(_ kind: Kind = .primary) {
        self.kind = kind
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .mimoFont(.body)
            .fontWeight(.medium)
            .foregroundStyle(foreground)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, minHeight: MimoMetrics.buttonHeight)
            .background(
                background,
                in: RoundedRectangle(cornerRadius: MimoMetrics.buttonRadius, style: .continuous)
            )
            .shadow(color: .black.opacity(hasShadow ? 0.08 : 0), radius: 8, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(duration: 0.25), value: configuration.isPressed)
    }

    private var foreground: Color {
        switch kind {
        case .primary: MimoColor.accent
        case .neutral, .secondary: MimoColor.textPrimary
        case .success: MimoColor.success
        case .dark: .white
        }
    }

    private var background: Color {
        switch kind {
        case .primary, .neutral: MimoColor.surface
        case .secondary: MimoColor.fill
        case .success: MimoColor.success.opacity(0.12)
        case .dark: MimoColor.darkSurface
        }
    }

    private var hasShadow: Bool {
        kind == .primary || kind == .neutral
    }
}

/// Botão circular de 44 pt: voltar, compartilhar, editar, configurações.
public struct MimoCircleButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(MimoColor.textPrimary)
            .frame(width: MimoMetrics.circleButton, height: MimoMetrics.circleButton)
            .background(MimoColor.surface, in: Circle())
            .mimoShadow()
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(duration: 0.25), value: configuration.isPressed)
    }
}

/// Cápsula bege compacta: "Ver tudo →", "Cancelar" em barras, código de convite.
public struct MimoPillButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .mimoFont(.bodySecondary)
            .fontWeight(.medium)
            .foregroundStyle(MimoColor.textPrimary)
            .padding(.horizontal, 16)
            .frame(minHeight: MimoMetrics.pillHeight)
            .background(MimoColor.fill, in: Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

public extension ButtonStyle where Self == MimoButtonStyle {
    static var mimoPrimary: MimoButtonStyle { MimoButtonStyle(.primary) }
    static var mimoNeutral: MimoButtonStyle { MimoButtonStyle(.neutral) }
    static var mimoSecondary: MimoButtonStyle { MimoButtonStyle(.secondary) }
    static var mimoDark: MimoButtonStyle { MimoButtonStyle(.dark) }
}

public extension ButtonStyle where Self == MimoCircleButtonStyle {
    static var mimoCircle: MimoCircleButtonStyle { MimoCircleButtonStyle() }
}

public extension ButtonStyle where Self == MimoPillButtonStyle {
    static var mimoPill: MimoPillButtonStyle { MimoPillButtonStyle() }
}
