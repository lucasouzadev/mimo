import SwiftUI

/// Estilos de texto do Mimo. Serifa para emoção, sans para função.
/// Todos escalam com o Dynamic Type a partir do tamanho base.
public enum MimoTextStyle: Sendable {
    /// 48 pt serifa — "Sua inbox", totais em dinheiro.
    case display
    /// 30 pt serifa — títulos de coleção e de desejo.
    case collectionTitle
    /// 28 pt serifa — títulos de seção.
    case sectionTitle
    /// 26 pt serifa maiúscula — marca no detalhe do produto.
    case brand
    /// 17 pt sans medium — título de barra.
    case navTitle
    /// 17 pt sans — listas, campos, botões.
    case body
    /// 15 pt sans — descrições.
    case bodySecondary
    /// 13 pt sans — legendas, domínio da loja, marca na grade.
    case caption
    /// 11 pt sans maiúscula espaçada — rótulos de seção.
    case overline

    var size: CGFloat {
        switch self {
        case .display: 48
        case .collectionTitle: 30
        case .sectionTitle: 28
        case .brand: 26
        case .navTitle, .body: 17
        case .bodySecondary: 15
        case .caption: 13
        case .overline: 11
        }
    }

    var weight: Font.Weight {
        switch self {
        case .navTitle: .medium
        default: .regular
        }
    }

    var design: Font.Design {
        switch self {
        case .display, .collectionTitle, .sectionTitle, .brand: .serif
        default: .default
        }
    }

    var relativeTo: Font.TextStyle {
        switch self {
        case .display: .largeTitle
        case .collectionTitle: .title
        case .sectionTitle, .brand: .title2
        case .navTitle: .headline
        case .body: .body
        case .bodySecondary: .subheadline
        case .caption: .caption
        case .overline: .caption2
        }
    }

    var tracking: CGFloat { self == .overline ? 0.8 : 0 }

    var isUppercase: Bool { self == .overline || self == .brand }
}

private struct MimoFontModifier: ViewModifier {
    let style: MimoTextStyle
    @ScaledMetric private var size: CGFloat

    init(style: MimoTextStyle) {
        self.style = style
        _size = ScaledMetric(wrappedValue: style.size, relativeTo: style.relativeTo)
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: style.weight, design: style.design))
            .tracking(style.tracking)
            .textCase(style.isUppercase ? .uppercase : nil)
    }
}

public extension View {
    /// Aplica um estilo de texto do Mimo.
    func mimoFont(_ style: MimoTextStyle) -> some View {
        modifier(MimoFontModifier(style: style))
    }
}
