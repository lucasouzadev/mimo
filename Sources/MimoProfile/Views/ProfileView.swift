import SwiftUI
import MimoDesignSystem
#if canImport(UIKit)
import UIKit
#endif

/// Estado inicial opcional da tela, para previews e capturas de tela do CI.
public enum ProfilePresentation: Sendable {
    /// Alerta "Recado para fãs" aberto.
    case noteAlert
    /// Alerta "Marcar como realizado?" aberto.
    case fulfillAlert
}

/// Aba Perfil: a lista de desejos do próprio usuário.
public struct ProfileScreen: View {
    @State private var model: ProfileModel
    private let presenting: ProfilePresentation?

    public init(model: ProfileModel, presenting: ProfilePresentation? = nil) {
        _model = State(initialValue: model)
        self.presenting = presenting
    }

    public var body: some View {
        NavigationStack {
            ProfileView(model: model, presenting: presenting)
        }
    }
}

/// Destinos ainda não implementados. Cada um vira uma tela própria nos próximos PRs.
enum ProfileSheet: Identifiable, Hashable {
    case newWish
    case reorder
    case edit(Wish.ID)
    case settings

    var id: Self { self }

    var title: String {
        switch self {
        case .newWish: "Novo desejo"
        case .reorder: "Reordenar desejos"
        case .edit: "Editar desejo"
        case .settings: "Preferências"
        }
    }
}

struct ProfileView: View {
    @Bindable var model: ProfileModel
    var presenting: ProfilePresentation?

    @State private var sheet: ProfileSheet?
    @State private var isEditingNote = false
    @State private var noteDraft = ""
    @State private var fulfillTarget: Wish.ID?
    @State private var giftedByDraft = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ProfileHeader(profile: model.profile) {
                    noteDraft = model.profile.note
                    isEditingNote = true
                }
                .padding(.horizontal, MimoMetrics.screenPadding)

                if !model.isChecklistComplete {
                    ChecklistCarousel(steps: model.checklist, pendingSteps: model.pendingSteps) { step in
                        model.completeStep(step.id)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                VStack(spacing: 16) {
                    filterBar
                    grid
                }
                .padding(.horizontal, MimoMetrics.screenPadding)
            }
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .mimoBackground()
        // Barra própria: ícones soltos, sem a cápsula de vidro da barra do sistema.
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top, spacing: 0) { topBar }
        .tint(MimoColor.textPrimary)
        .animation(.snappy, value: model.isChecklistComplete)
        .sheet(item: $sheet) { sheet in
            ComingSoonSheet(title: sheet.title)
        }
        .mimoAlert(
            isPresented: $isEditingNote,
            icon: "star.bubble.fill",
            title: "Recado para fãs",
            message: "Conte o que está pensando: um aniversário chegando ou seus desejos favoritos.",
            text: $noteDraft,
            placeholder: "Escreva um recado"
        ) {
            model.updateNote(noteDraft)
        }
        .mimoAlert(
            isPresented: isFulfilling,
            icon: "gift.fill",
            title: "Marcar como realizado?",
            message: "Ele vai aparecer como presente na sua inbox.",
            text: $giftedByDraft,
            placeholder: "Quem presenteou? (opcional)",
            confirmTitle: "Confirmar"
        ) {
            if let id = fulfillTarget {
                model.markFulfilled(id, giftedBy: giftedByDraft)
            }
        }
        .task { await presentInitialState() }
    }

    // MARK: Barra superior

    private var topBar: some View {
        HStack(spacing: 22) {
            Spacer()
            Button {
                sheet = .settings
            } label: {
                Image(systemName: "gearshape")
            }
            .accessibilityLabel("Preferências")

            ShareLink(item: model.profile.publicURL) {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Compartilhar lista")
        }
        .buttonStyle(.plain)
        .font(.system(size: 21))
        .foregroundStyle(MimoColor.textPrimary)
        .padding(.horizontal, MimoMetrics.screenPadding)
        .frame(height: 44)
    }

    // MARK: Filtros

    private var filterBar: some View {
        // Sem itens arquivados, o filtro "Arquivo" some e sobra só a contagem.
        let showsArchive = !model.archivedWishes.isEmpty || model.filter == .archived

        return HStack(spacing: 8) {
            MimoChip(
                model.activeWishes.count == 1 ? "1 desejo" : "\(model.activeWishes.count) desejos",
                isSelected: showsArchive && model.filter == .active,
                style: .segment
            ) {
                model.filter = .active
            }
            if showsArchive {
                MimoChip(
                    "Arquivo \(model.archivedWishes.count)",
                    isSelected: model.filter == .archived,
                    style: .segment
                ) {
                    model.filter = .archived
                }
            }
            Spacer()
            Button {
                sheet = .reorder
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(MimoColor.textPrimary)
                    .frame(width: MimoMetrics.chipHeight, height: MimoMetrics.chipHeight)
                    .background(MimoColor.fill, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Reordenar desejos")
        }
    }

    // MARK: Grade

    @ViewBuilder
    private var grid: some View {
        if model.filter == .archived && model.archivedWishes.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "archivebox")
                    .font(.system(size: 30, weight: .light))
                Text("Nada arquivado")
                    .mimoFont(.sectionTitle)
                Text("Desejos arquivados ficam guardados aqui, fora da sua lista pública.")
                    .mimoFont(.bodySecondary)
                    .foregroundStyle(MimoColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(MimoColor.textPrimary)
            .padding(.top, 40)
        } else {
            MasonryLayout(columns: 2, spacing: MimoMetrics.gridSpacing) {
                if model.filter == .active {
                    AddWishCard { sheet = .newWish }
                }
                ForEach(model.visibleWishes) { wish in
                    WishCard(
                        wish: wish,
                        onUnarchive: wish.isArchived ? { withAnimation(.snappy) { model.unarchive(wish.id) } } : nil
                    )
                    .contextMenu {
                        menu(for: wish)
                    } preview: {
                        WishCard(wish: wish)
                            .frame(width: 240)
                            .padding(16)
                            .background(MimoColor.backgroundTop)
                    }
                }
            }
            .animation(.snappy, value: model.visibleWishes)
        }
    }

    @ViewBuilder
    private func menu(for wish: Wish) -> some View {
        let link = model.profile.url(for: wish)

        ShareLink(item: link) {
            Label("Compartilhar", systemImage: "square.and.arrow.up")
        }
        Button {
            copy(link.absoluteString)
        } label: {
            Label("Copiar link", systemImage: "link")
        }
        Button {
            sheet = .edit(wish.id)
        } label: {
            Label("Editar", systemImage: "pencil")
        }
        if !wish.isArchived {
            Button {
                model.togglePin(wish.id)
            } label: {
                Label(wish.isPinned ? "Desafixar" : "Fixar", systemImage: wish.isPinned ? "pin.slash" : "pin")
            }
        }

        Divider()

        if !wish.isFulfilled {
            Button {
                giftedByDraft = ""
                fulfillTarget = wish.id
            } label: {
                Label("Marcar como realizado", systemImage: "gift")
            }
        }
        Button {
            if wish.isArchived {
                model.unarchive(wish.id)
            } else {
                model.archive(wish.id)
            }
        } label: {
            Label(wish.isArchived ? "Desarquivar" : "Arquivar", systemImage: "archivebox")
        }
        Button(role: .destructive) {
            model.delete(wish.id)
        } label: {
            Label("Excluir", systemImage: "trash")
        }
    }

    // MARK: Auxiliares

    private var isFulfilling: Binding<Bool> {
        Binding(
            get: { fulfillTarget != nil },
            set: { if !$0 { fulfillTarget = nil } }
        )
    }

    private func presentInitialState() async {
        guard let presenting else { return }
        try? await Task.sleep(for: .milliseconds(500))
        switch presenting {
        case .noteAlert:
            noteDraft = model.profile.note
            isEditingNote = true
        case .fulfillAlert:
            giftedByDraft = ""
            fulfillTarget = model.activeWishes.first?.id
        }
    }

    private func copy(_ text: String) {
        #if canImport(UIKit)
        UIPasteboard.general.string = text
        #endif
    }
}

/// Placeholder para telas dos próximos PRs.
struct ComingSoonSheet: View {
    let title: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            MimoEmptyState(icon: "hammer", title: title, message: "Esta tela entra num próximo PR.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .mimoBackground()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Fechar") { dismiss() }
                    }
                }
        }
        .presentationDetents([.large])
        .presentationCornerRadius(32)
    }
}

#Preview("Perfil") {
    ProfileScreen(model: .sample())
}

#Preview("Perfil — arquivo") {
    let model = ProfileModel.sample()
    model.filter = .archived
    return ProfileScreen(model: model)
}

#Preview("Perfil — recado") {
    ProfileScreen(model: .sample(), presenting: .noteAlert)
}
