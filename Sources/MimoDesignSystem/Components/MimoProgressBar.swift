import SwiftUI

/// Barra de vaquinha: 4 pt, azul sobre bege, rótulos opcionais nas pontas.
public struct MimoProgressBar: View {
    private let value: Double
    private let leadingLabel: String?
    private let trailingLabel: String?
    private let height: CGFloat

    public init(value: Double, leadingLabel: String? = nil, trailingLabel: String? = nil, height: CGFloat = 4) {
        self.value = value
        self.leadingLabel = leadingLabel
        self.trailingLabel = trailingLabel
        self.height = height
    }

    private var clamped: Double { min(max(value, 0), 1) }

    public var body: some View {
        VStack(spacing: 6) {
            if leadingLabel != nil || trailingLabel != nil {
                HStack {
                    if let leadingLabel {
                        Text(leadingLabel).foregroundStyle(MimoColor.textSecondary)
                    }
                    Spacer()
                    if let trailingLabel {
                        Text(trailingLabel).foregroundStyle(MimoColor.accent)
                    }
                }
                .mimoFont(.caption)
            }
            Capsule()
                .fill(MimoColor.fill)
                .frame(height: height)
                .overlay(alignment: .leading) {
                    GeometryReader { proxy in
                        Capsule()
                            .fill(MimoColor.accent)
                            .frame(width: proxy.size.width * clamped)
                    }
                }
                .animation(.smooth, value: clamped)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(leadingLabel ?? "Progresso")
        .accessibilityValue(Text(clamped, format: .percent.precision(.fractionLength(0))))
    }
}
