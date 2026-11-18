import SwiftUI

/// Cartão de ação branco com ícone, título, texto e botão interno.
/// Usado no checklist "Ative sua lista" e nos avisos de recebimento.
public struct MimoActionCard: View {
    private let icon: String
    private let iconTint: Color
    private let title: String
    private let message: String
    private let buttonTitle: String
    private let isDone: Bool
    private let action: () -> Void

    public init(
        icon: String,
        iconTint: Color = MimoColor.accent,
        title: String,
        message: String,
        buttonTitle: String,
        isDone: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.isDone = isDone
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isDone ? "checkmark.circle.fill" : icon)
                .font(.system(size: 22))
                .foregroundStyle(isDone ? MimoColor.success : iconTint)
                .contentTransition(.symbolEffect(.replace))
            Text(title)
                .mimoFont(.body)
                .fontWeight(.semibold)
                .foregroundStyle(MimoColor.textPrimary)
            Text(message)
                .mimoFont(.bodySecondary)
                .foregroundStyle(MimoColor.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Button(action: action) {
                if isDone {
                    Label("Feito", systemImage: "checkmark")
                } else {
                    Text(buttonTitle)
                }
            }
            .buttonStyle(MimoButtonStyle(isDone ? .success : .secondary))
            .disabled(isDone)
            .padding(.top, 8)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            MimoColor.surface,
            in: RoundedRectangle(cornerRadius: MimoMetrics.cardRadius, style: .continuous)
        )
        .mimoShadow()
    }
}

/// Linha de preferência: título e legenda à esquerda, controle à direita.
/// Fica direto sobre o fundo, sem cartão nem divisória.
public struct MimoPreferenceRow<Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let trailing: Trailing

    public init(_ title: String, subtitle: String? = nil, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .mimoFont(.body)
                    .foregroundStyle(MimoColor.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .mimoFont(.caption)
                        .foregroundStyle(MimoColor.textSecondary)
                }
            }
            Spacer(minLength: 12)
            trailing
        }
        .padding(.vertical, 10)
    }
}

/// Estado vazio: ícone em traço, título em serifa grande, legenda curta.
public struct MimoEmptyState: View {
    private let icon: String
    private let title: String
    private let message: String

    public init(icon: String, title: String, message: String) {
        self.icon = icon
        self.title = title
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 34, weight: .light))
            Text(title)
                .mimoFont(.display)
                .multilineTextAlignment(.center)
            Text(message)
                .mimoFont(.bodySecondary)
                .foregroundStyle(MimoColor.textSecondary)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(MimoColor.textPrimary)
        .padding(.horizontal, MimoMetrics.screenPadding)
    }
}
