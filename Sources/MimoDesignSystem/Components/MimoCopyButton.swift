import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Copia um valor e confirma no próprio botão por 2 s, sem toast.
public struct MimoCopyButton: View {
    public enum Style: Sendable {
        /// Cápsula bege: código de convite.
        case pill
        /// Texto cinza com ícone, sem fundo: link público no perfil.
        case plain
    }

    private let label: String
    private let value: String
    private let copiedLabel: String
    private let style: Style

    @State private var copied = false
    @State private var resetTask: Task<Void, Never>?

    public init(_ label: String, value: String, copiedLabel: String = "Copiado", style: Style = .pill) {
        self.label = label
        self.value = value
        self.copiedLabel = copiedLabel
        self.style = style
    }

    public var body: some View {
        switch style {
        case .pill:
            button
                .buttonStyle(.mimoPill)
        case .plain:
            button
                .buttonStyle(.plain)
                .mimoFont(.body)
                .foregroundStyle(MimoColor.textSecondary)
        }
    }

    private var button: some View {
        Button(action: copy) {
            HStack(spacing: 6) {
                Text(copied ? copiedLabel : label)
                    .lineLimit(1)
                    .contentTransition(.opacity)
                Image(systemName: copied ? "checkmark" : "square.on.square")
                    .imageScale(.small)
                    .frame(width: 18)
                    .contentTransition(.symbolEffect(.replace))
            }
        }
        .animation(.snappy, value: copied)
        .sensoryFeedback(.success, trigger: copied) { _, isCopied in isCopied }
    }

    private func copy() {
        #if canImport(UIKit)
        UIPasteboard.general.string = value
        #endif
        copied = true
        resetTask?.cancel()
        resetTask = Task {
            try? await Task.sleep(for: .seconds(2))
            guard !Task.isCancelled else { return }
            copied = false
        }
    }
}
