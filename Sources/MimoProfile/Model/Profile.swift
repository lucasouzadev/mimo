import Foundation

/// Endereço público das listas. Substitua pelo domínio definitivo do Mimo.
public enum MimoLinks {
    public static let host = "mimo.example"
}

/// Dados públicos do criador da lista.
public struct Profile: Hashable, Sendable {
    public var name: String
    public var emoji: String?
    public var handle: String
    public var avatarURL: URL?
    public var birthday: Date?
    public var showsBirthday: Bool
    /// Recado curto exibido no balão acima do avatar.
    public var note: String

    public init(
        name: String,
        emoji: String? = nil,
        handle: String,
        avatarURL: URL? = nil,
        birthday: Date? = nil,
        showsBirthday: Bool = true,
        note: String = ""
    ) {
        self.name = name
        self.emoji = emoji
        self.handle = handle
        self.avatarURL = avatarURL
        self.birthday = birthday
        self.showsBirthday = showsBirthday
        self.note = note
    }

    /// "mimo.example/handle", para exibir.
    public var displayLink: String { "\(MimoLinks.host)/\(handle)" }

    public var publicURL: URL {
        URL(string: "https://\(MimoLinks.host)/\(handle)")!
    }

    public func url(for wish: Wish) -> URL {
        publicURL.appending(path: wish.id.uuidString.lowercased())
    }

    public var initials: String {
        name.split(separator: " ").prefix(2).compactMap(\.first).map(String.init).joined()
    }
}

/// Uma etapa do checklist "Ative sua lista".
public struct ChecklistStep: Identifiable, Hashable, Sendable {
    public let id: String
    public var icon: String
    public var title: String
    public var message: String
    public var buttonTitle: String
    public var isDone: Bool

    public init(id: String, icon: String, title: String, message: String, buttonTitle: String, isDone: Bool = false) {
        self.id = id
        self.icon = icon
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.isDone = isDone
    }
}
