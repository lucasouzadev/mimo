import SwiftUI

/// Catálogo de componentes, usado no Canvas do Xcode e nas capturas do CI.
public struct MimoGallery: View {
    @State private var added = false
    @State private var category = "Roupas"
    @State private var quickValue = 100
    @State private var showBirthday = true
    @State private var showNote = false
    @State private var note = ""

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                section("Tipografia") {
                    Text("Sua inbox").mimoFont(.display)
                    Text("Edição Mesa Posta").mimoFont(.collectionTitle)
                    Text("Ganhe recompensas").mimoFont(.sectionTitle)
                    Text("Marca").mimoFont(.brand)
                    Text("Corpo de texto").mimoFont(.body)
                    Text("Descrição secundária").mimoFont(.bodySecondary)
                        .foregroundStyle(MimoColor.textSecondary)
                    Text("Desejos fixados").mimoFont(.overline)
                        .foregroundStyle(MimoColor.textSecondary)
                }

                section("Botões") {
                    Button {} label: { Label("Adicionar à lista", systemImage: "plus.circle.fill") }
                        .buttonStyle(.mimoPrimary)
                    Button("Conectar conta bancária") {}
                        .buttonStyle(.mimoSecondary)
                    HStack(spacing: 12) {
                        Button {} label: { Image(systemName: "chevron.left") }
                            .buttonStyle(.mimoCircle)
                        Button {} label: { Image(systemName: "square.and.arrow.up") }
                            .buttonStyle(.mimoCircle)
                        Button("Ver tudo →") {}
                            .buttonStyle(.mimoPill)
                    }
                    HStack(spacing: 16) {
                        MimoCopyButton("MIMO42", value: "MIMO42")
                        MimoCopyButton("mimo.example/luca", value: "https://mimo.example/luca", copiedLabel: "Link copiado", style: .plain)
                    }
                }

                section("Cartões de produto") {
                    HStack(alignment: .top, spacing: MimoMetrics.gridSpacing) {
                        MimoProductCard(
                            brand: "Marca",
                            name: "Fone sem fio com cancelamento de ruído",
                            price: 2499,
                            imageURL: nil,
                            isAdded: added
                        ) { added.toggle() }
                        MimoProductCard(
                            brand: "Ateliê",
                            name: "Vaso de cerâmica pintado à mão",
                            price: 380,
                            imageURL: nil
                        ) {}
                    }
                }

                section("Campos e chips") {
                    TextField("Dê um nome ao desejo", text: .constant(""))
                        .mimoField()
                    TextField("Adicione um link", text: .constant(""))
                        .mimoField(.secondary, icon: "link")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(["Roupas", "Tech", "Casa", "Beleza"], id: \.self) { item in
                                MimoChip(item, isSelected: category == item) { category = item }
                            }
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach([25, 50, 100, 250], id: \.self) { value in
                            MimoChip("R$ \(value)", isSelected: quickValue == value, style: .value) {
                                quickValue = value
                            }
                        }
                    }
                }

                section("Progresso e preferências") {
                    MimoProgressBar(value: 0.62, leadingLabel: "62% arrecadado", trailingLabel: "Meta R$ 2.499")
                    Toggle(isOn: $showBirthday) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Mostrar aniversário no perfil").mimoFont(.body)
                            Text("Transforme seu dia num evento de presentes")
                                .mimoFont(.caption)
                                .foregroundStyle(MimoColor.textSecondary)
                        }
                    }
                    .toggleStyle(.mimoCheck)
                    MimoPreferenceRow("Recado para fãs", subtitle: note.isEmpty ? "Nenhum" : note) {
                        Button("Editar") { showNote = true }
                            .buttonStyle(.mimoPill)
                    }
                }

                section("Cartões de ação") {
                    MimoActionCard(
                        icon: "dollarsign.circle.fill",
                        title: "Configure os recebimentos",
                        message: "Ninguém consegue te presentear até você configurar os recebimentos.",
                        buttonTitle: "Conectar conta bancária"
                    ) {}
                    MimoActionCard(
                        icon: "person.crop.circle",
                        title: "Foto e nome definidos",
                        message: "Agora fica muito mais fácil ser mimado!",
                        buttonTitle: "",
                        isDone: true
                    ) {}
                }

                MimoEmptyState(
                    icon: "tray",
                    title: "Sua inbox",
                    message: "É onde seus desejos\nvão se realizar"
                )
                .frame(maxWidth: .infinity)
            }
            .padding(MimoMetrics.screenPadding)
        }
        .mimoBackground()
        .mimoAlert(
            isPresented: $showNote,
            icon: "star.bubble.fill",
            title: "Recado para fãs",
            message: "Conte o que está pensando — um aniversário chegando ou seus desejos favoritos",
            text: $note,
            placeholder: "Escreva um recado"
        ) {}
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .mimoFont(.overline)
                .foregroundStyle(MimoColor.textSecondary)
            content()
        }
    }
}

// MARK: - Abas de exemplo

private enum GalleryTab: String, MimoTab {
    case discover, inbox, earn, profile

    var title: String {
        switch self {
        case .discover: "Descobrir"
        case .inbox: "Inbox"
        case .earn: "Ganhar"
        case .profile: "Perfil"
        }
    }

    var systemImage: String {
        switch self {
        case .discover: "house"
        case .inbox: "tray"
        case .earn: "dollarsign.circle"
        case .profile: "person.crop.circle"
        }
    }
}

private struct GalleryTabs: View {
    @State private var tab: GalleryTab = .discover

    var body: some View {
        MimoTabContainer(selection: $tab) { tab in
            switch tab {
            case .discover: MimoGallery()
            default:
                MimoEmptyState(icon: tab.systemImage, title: tab.title, message: "Em construção")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .mimoBackground()
            }
        }
    }
}

#Preview("Componentes") {
    MimoGallery()
}

#Preview("Abas") {
    GalleryTabs()
}
