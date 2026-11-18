import Foundation
import Observation

public enum WishFilter: Hashable, Sendable {
    case active
    case archived
}

/// Estado da tela de Perfil. Por enquanto em memória;
/// a camada local-first (SwiftData/GRDB + sync) entra no lugar depois.
@Observable
@MainActor
public final class ProfileModel {
    public var profile: Profile
    public private(set) var wishes: [Wish]
    public private(set) var checklist: [ChecklistStep]
    public var filter: WishFilter = .active

    public init(profile: Profile, wishes: [Wish], checklist: [ChecklistStep]) {
        self.profile = profile
        self.wishes = wishes
        self.checklist = checklist
    }

    // MARK: Leitura

    /// Fixados primeiro, mantendo a ordem da lista.
    public var activeWishes: [Wish] {
        let active = wishes.filter { !$0.isArchived }
        return active.filter(\.isPinned) + active.filter { !$0.isPinned }
    }

    public var archivedWishes: [Wish] {
        wishes.filter(\.isArchived)
    }

    public var visibleWishes: [Wish] {
        filter == .active ? activeWishes : archivedWishes
    }

    public var pendingSteps: Int {
        checklist.filter { !$0.isDone }.count
    }

    public var isChecklistComplete: Bool { pendingSteps == 0 }

    public func wish(id: Wish.ID) -> Wish? {
        wishes.first { $0.id == id }
    }

    // MARK: Ações

    public func updateNote(_ note: String) {
        profile.note = note.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func togglePin(_ id: Wish.ID) {
        mutate(id) { $0.isPinned.toggle() }
    }

    public func archive(_ id: Wish.ID) {
        mutate(id) {
            $0.isArchived = true
            $0.isPinned = false
        }
    }

    public func unarchive(_ id: Wish.ID) {
        mutate(id) { $0.isArchived = false }
    }

    public func delete(_ id: Wish.ID) {
        wishes.removeAll { $0.id == id }
    }

    /// Registra o desejo como realizado. Ele passa a aparecer como presente na Inbox.
    public func markFulfilled(_ id: Wish.ID, giftedBy: String?) {
        let name = giftedBy?.trimmingCharacters(in: .whitespacesAndNewlines)
        mutate(id) {
            $0.isFulfilled = true
            $0.raised = $0.price
            $0.giftedBy = (name?.isEmpty ?? true) ? nil : name
        }
    }

    public func completeStep(_ id: ChecklistStep.ID) {
        guard let index = checklist.firstIndex(where: { $0.id == id }) else { return }
        checklist[index].isDone = true
    }

    private func mutate(_ id: Wish.ID, _ change: (inout Wish) -> Void) {
        guard let index = wishes.firstIndex(where: { $0.id == id }) else { return }
        change(&wishes[index])
    }
}
