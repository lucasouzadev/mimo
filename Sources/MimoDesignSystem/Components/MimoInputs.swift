import SwiftUI

public enum MimoFieldProminence: Sendable {
    /// Cápsula branca: campo obrigatório (nome, preço).
    case primary
    /// Cápsula bege: campo opcional (link, comentário).
    case secondary
}

private struct MimoFieldModifier: ViewModifier {
    let prominence: MimoFieldProminence
    let icon: String?

    func body(content: Content) -> some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(MimoColor.textSecondary)
            }
            content
                .mimoFont(.body)
                .foregroundStyle(MimoColor.textPrimary)
        }
        .padding(.horizontal, 18)
        .frame(minHeight: MimoMetrics.fieldHeight)
        .background(
            prominence == .primary ? MimoColor.surface : MimoColor.fill,
            in: RoundedRectangle(cornerRadius: MimoMetrics.buttonRadius, style: .continuous)
        )
    }
}

public extension View {
    /// Transforma um `TextField` no campo em cápsula do Mimo.
    func mimoField(_ prominence: MimoFieldProminence = .primary, icon: String? = nil) -> some View {
        modifier(MimoFieldModifier(prominence: prominence, icon: icon))
    }
}

/// Chip em cápsula de 40 pt.
public struct MimoChip: View {
    public enum Style: Sendable {
        /// Abas de filtro: ativa com fundo bege escuro, as demais só texto cinza.
        case segment
        /// Ativo em preto com texto branco: categorias do catálogo.
        case category
        /// Fundo bege, ativo em bege escuro: valores rápidos (R$ 25, R$ 50…).
        case value
    }

    private let title: String
    private let isSelected: Bool
    private let style: Style
    private let action: () -> Void

    public init(_ title: String, isSelected: Bool = false, style: Style = .category, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .mimoFont(.bodySecondary)
                .fontWeight(.medium)
                .foregroundStyle(foreground)
                .padding(.horizontal, 16)
                .frame(minHeight: MimoMetrics.chipHeight)
                .background(background, in: Capsule())
        }
        .buttonStyle(.plain)
        .animation(.snappy, value: isSelected)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var foreground: Color {
        switch (style, isSelected) {
        case (.category, true): .white
        case (.segment, false): MimoColor.textSecondary
        default: MimoColor.textPrimary
        }
    }

    private var background: Color {
        switch (style, isSelected) {
        case (.category, true): MimoColor.textPrimary
        case (.category, false), (.segment, false): .clear
        case (.segment, true): MimoColor.fillStrong
        case (.value, true): MimoColor.fillStrong
        case (.value, false): MimoColor.fill
        }
    }
}

/// Toggle em cápsula que mostra ✓ quando ligado.
public struct MimoCheckToggleStyle: ToggleStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 12) {
                configuration.label
                Spacer(minLength: 12)
                ZStack {
                    Capsule()
                        .fill(configuration.isOn ? MimoColor.surface : MimoColor.fill)
                        .frame(width: 52, height: 32)
                        .shadow(color: .black.opacity(configuration.isOn ? 0.06 : 0), radius: 4, y: 2)
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(MimoColor.textPrimary)
                        .opacity(configuration.isOn ? 1 : 0)
                        .scaleEffect(configuration.isOn ? 1 : 0.5)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.snappy, value: configuration.isOn)
        .sensoryFeedback(.selection, trigger: configuration.isOn)
        .accessibilityAddTraits(.isToggle)
        .accessibilityValue(configuration.isOn ? "Ligado" : "Desligado")
    }
}

public extension ToggleStyle where Self == MimoCheckToggleStyle {
    static var mimoCheck: MimoCheckToggleStyle { MimoCheckToggleStyle() }
}
