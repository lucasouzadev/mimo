import SwiftUI

/// Uma aba do app. Implemente com um `enum`.
public protocol MimoTab: Hashable, CaseIterable where AllCases: RandomAccessCollection {
    var title: String { get }
    var systemImage: String { get }
}

/// Contêiner de abas do Mimo.
/// - iOS 26+: `TabView` nativo, com o vidro do sistema.
/// - iOS 18: a barra do sistema é escondida e uma pílula flutuante própria assume.
///
/// As telas não precisam saber qual das duas está ativa.
public struct MimoTabContainer<T: MimoTab, Content: View>: View {
    @Binding private var selection: T
    private let content: (T) -> Content

    public init(selection: Binding<T>, @ViewBuilder content: @escaping (T) -> Content) {
        _selection = selection
        self.content = content
    }

    public var body: some View {
        if #available(iOS 26, *) {
            TabView(selection: $selection) {
                ForEach(T.allCases, id: \.self) { tab in
                    Tab(tab.title, systemImage: tab.systemImage, value: tab) {
                        content(tab)
                    }
                }
            }
            .tint(MimoColor.textPrimary)
        } else {
            TabView(selection: $selection) {
                ForEach(T.allCases, id: \.self) { tab in
                    content(tab)
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: MimoMetrics.tabBarHeight + 8)
                        }
                        .toolbar(.hidden, for: .tabBar)
                        .tag(tab)
                }
            }
            .overlay(alignment: .bottom) {
                MimoFloatingTabBar(selection: $selection)
                    .padding(.horizontal, MimoMetrics.screenPadding)
                    .padding(.bottom, 4)
            }
        }
    }
}

/// Pílula flutuante usada no iOS 18.
struct MimoFloatingTabBar<T: MimoTab>: View {
    @Binding var selection: T
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(T.allCases, id: \.self) { tab in
                let isActive = selection == tab
                Button {
                    selection = tab
                } label: {
                    Image(systemName: tab.systemImage)
                        .symbolVariant(isActive ? .fill : .none)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(MimoColor.textPrimary)
                        .frame(maxWidth: .infinity, minHeight: MimoMetrics.tabBarHeight - 8)
                        .background {
                            if isActive {
                                Capsule()
                                    .fill(MimoColor.textPrimary.opacity(0.08))
                                    .matchedGeometryEffect(id: "active", in: namespace)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
                .accessibilityAddTraits(isActive ? .isSelected : [])
            }
        }
        .padding(4)
        .mimoGlass(in: Capsule())
        .animation(.spring(duration: 0.3, bounce: 0.2), value: selection)
        .sensoryFeedback(.selection, trigger: selection)
    }
}
