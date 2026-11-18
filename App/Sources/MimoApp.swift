import SwiftUI
import MimoDesignSystem
import MimoProfile

@main
struct MimoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

enum AppTab: String, MimoTab {
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

/// Tela inicial a abrir, passada como argumento de inicialização
/// (`-screen profile`). Usado pelo CI para gerar capturas.
enum LaunchScreen: String {
    /// Perfil com o checklist "Ative sua lista".
    case profile
    /// Perfil com o checklist concluído: a grade sobe.
    case wishes
    /// Perfil no filtro Arquivo.
    case archive
    /// Catálogo de componentes.
    case gallery
    /// Perfil com o alerta "Recado para fãs" aberto.
    case note
    /// Perfil com o alerta "Marcar como realizado?" aberto.
    case fulfill

    static var current: LaunchScreen {
        UserDefaults.standard.string(forKey: "screen").flatMap(LaunchScreen.init) ?? .profile
    }
}

struct RootView: View {
    @State private var tab: AppTab = .profile
    @State private var profileModel: ProfileModel
    private let screen = LaunchScreen.current

    private var presentation: ProfilePresentation? {
        switch screen {
        case .note: .noteAlert
        case .fulfill: .fulfillAlert
        default: nil
        }
    }

    init() {
        let model = ProfileModel.sample()
        switch LaunchScreen.current {
        case .wishes:
            model.checklist.map(\.id).forEach(model.completeStep)
        case .archive:
            model.checklist.map(\.id).forEach(model.completeStep)
            model.filter = .archived
        case .note, .fulfill:
            model.checklist.map(\.id).forEach(model.completeStep)
        case .profile, .gallery:
            break
        }
        _profileModel = State(initialValue: model)
    }

    var body: some View {
        if screen == .gallery {
            MimoGallery()
        } else {
            MimoTabContainer(selection: $tab) { tab in
                switch tab {
                case .profile:
                    ProfileScreen(model: profileModel, presenting: presentation)
                default:
                    MimoEmptyState(icon: tab.systemImage, title: tab.title, message: "Em construção")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .mimoBackground()
                }
            }
        }
    }
}
