import Foundation

/// Um item da lista de desejos.
public struct Wish: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var name: String
    public var price: Decimal
    public var imageURL: URL?
    /// Largura / altura da foto. Define a altura do cartão na grade.
    public var aspectRatio: CGFloat
    /// Símbolo e cor usados enquanto não há foto.
    public var placeholderSymbol: String
    public var placeholderTint: UInt32
    public var storeDomain: String?
    public var isPinned: Bool
    public var isArchived: Bool
    public var isCrowdfunding: Bool
    public var raised: Decimal
    public var isFulfilled: Bool
    public var giftedBy: String?

    public init(
        id: UUID = UUID(),
        name: String,
        price: Decimal,
        imageURL: URL? = nil,
        aspectRatio: CGFloat = 0.85,
        placeholderSymbol: String = "gift",
        placeholderTint: UInt32 = 0xE9DFC9,
        storeDomain: String? = nil,
        isPinned: Bool = false,
        isArchived: Bool = false,
        isCrowdfunding: Bool = false,
        raised: Decimal = 0,
        isFulfilled: Bool = false,
        giftedBy: String? = nil
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.imageURL = imageURL
        self.aspectRatio = aspectRatio
        self.placeholderSymbol = placeholderSymbol
        self.placeholderTint = placeholderTint
        self.storeDomain = storeDomain
        self.isPinned = isPinned
        self.isArchived = isArchived
        self.isCrowdfunding = isCrowdfunding
        self.raised = raised
        self.isFulfilled = isFulfilled
        self.giftedBy = giftedBy
    }

    /// Fração arrecadada, de 0 a 1.
    public var progress: Double {
        guard price > 0 else { return 0 }
        let ratio = NSDecimalNumber(decimal: raised / price).doubleValue
        return min(max(ratio, 0), 1)
    }

    /// Mostra a barra de progresso no cartão.
    public var showsProgress: Bool {
        isCrowdfunding || raised > 0
    }
}
