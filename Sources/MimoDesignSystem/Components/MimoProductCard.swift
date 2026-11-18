import SwiftUI

/// Cartão de produto da grade e dos carrosséis.
/// Foto sobre branco com raio 16, botão "+" no canto, marca, nome e preço abaixo.
public struct MimoProductCard: View {
    private let brand: String?
    private let name: String
    private let price: Decimal
    private let currencyCode: String
    private let imageURL: URL?
    private let isAdded: Bool
    private let onAdd: (() -> Void)?

    public init(
        brand: String? = nil,
        name: String,
        price: Decimal,
        currencyCode: String = "BRL",
        imageURL: URL?,
        isAdded: Bool = false,
        onAdd: (() -> Void)? = nil
    ) {
        self.brand = brand
        self.name = name
        self.price = price
        self.currencyCode = currencyCode
        self.imageURL = imageURL
        self.isAdded = isAdded
        self.onAdd = onAdd
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            photo
            VStack(alignment: .leading, spacing: 2) {
                if let brand {
                    Text(brand)
                        .mimoFont(.caption)
                        .textCase(.uppercase)
                        .foregroundStyle(MimoColor.textSecondary)
                }
                Text(name)
                    .mimoFont(.bodySecondary)
                    .foregroundStyle(MimoColor.textPrimary)
                    .lineLimit(2)
                Text(price, format: .currency(code: currencyCode))
                    .mimoFont(.bodySecondary)
                    .foregroundStyle(MimoColor.textSecondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var photo: some View {
        Color.white
            .aspectRatio(163.0 / 190.0, contentMode: .fit)
            .overlay {
                AsyncImage(url: imageURL, transaction: Transaction(animation: .easeOut(duration: 0.25))) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .transition(.opacity)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundStyle(MimoColor.textSecondary)
                    default:
                        MimoColor.fill
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: MimoMetrics.imageRadius, style: .continuous))
            .overlay(alignment: .bottomTrailing) {
                if let onAdd {
                    addButton(action: onAdd)
                }
            }
    }

    private func addButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: isAdded ? "checkmark" : "plus")
                .font(.system(size: 13, weight: .bold))
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(MimoColor.textPrimary)
                .frame(width: 28, height: 28)
                .background(MimoColor.surface, in: Circle())
                .mimoShadow()
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .light), trigger: isAdded)
        .accessibilityLabel(isAdded ? "Adicionado à lista" : "Adicionar à lista")
    }
}
