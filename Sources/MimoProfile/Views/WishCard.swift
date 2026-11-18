import SwiftUI
import MimoDesignSystem

/// Cartão de desejo da grade do Perfil.
struct WishCard: View {
    let wish: Wish
    var currencyCode = "BRL"
    var onUnarchive: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WishImage(wish: wish)
                .aspectRatio(wish.aspectRatio, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: MimoMetrics.imageRadius, style: .continuous))
                .overlay(alignment: .topLeading) {
                    if wish.isPinned {
                        badge(systemImage: "pin.fill")
                            .accessibilityLabel("Fixado")
                    }
                }
                .overlay(alignment: .topTrailing) {
                    if wish.isFulfilled {
                        badge(systemImage: "checkmark")
                            .accessibilityLabel("Realizado")
                    }
                }
                .overlay(alignment: .bottom) {
                    if let onUnarchive {
                        Button("Desarquivar", action: onUnarchive)
                            .mimoFont(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(MimoColor.textPrimary)
                            .padding(.horizontal, 14)
                            .frame(minHeight: 32)
                            .background(MimoColor.surface, in: Capsule())
                            .mimoShadow()
                            .padding(10)
                            .buttonStyle(.plain)
                    }
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(wish.name)
                    .mimoFont(.bodySecondary)
                    .foregroundStyle(MimoColor.textPrimary)
                    .lineLimit(2)
                Text(wish.price, format: .currency(code: currencyCode))
                    .mimoFont(.bodySecondary)
                    .foregroundStyle(MimoColor.textSecondary)
            }

            if wish.showsProgress {
                MimoProgressBar(value: wish.progress)
            }
        }
        .contentShape(Rectangle())
    }

    private func badge(systemImage: String) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(MimoColor.textPrimary)
            .frame(width: 26, height: 26)
            .background(MimoColor.surface, in: Circle())
            .mimoShadow()
            .padding(8)
    }
}

/// Foto do desejo ou, sem foto, um bloco colorido com símbolo.
struct WishImage: View {
    let wish: Wish

    var body: some View {
        Color(hex: wish.placeholderTint)
            .overlay {
                if let url = wish.imageURL {
                    AsyncImage(url: url, transaction: Transaction(animation: .easeOut(duration: 0.25))) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill().transition(.opacity)
                        default:
                            placeholderSymbol
                        }
                    }
                } else {
                    placeholderSymbol
                }
            }
            .clipped()
    }

    private var placeholderSymbol: some View {
        Image(systemName: wish.placeholderSymbol)
            .font(.system(size: 34, weight: .light))
            .foregroundStyle(MimoColor.textPrimary.opacity(0.55))
    }
}

/// Primeira célula da grade: abre o sheet de novo desejo.
struct AddWishCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            MimoColor.fill
                .aspectRatio(163.0 / 150.0, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: MimoMetrics.imageRadius, style: .continuous))
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .medium))
                        Text("Desejo")
                            .mimoFont(.body)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(MimoColor.textPrimary)
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Adicionar desejo")
    }
}
