import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Copia um valor e confirma no próprio botão por 2 s, sem toast.
public struct MimoCopyButton: View {
    private let label: String
    private let value: String
    private let copiedLabel: String

    @State private var copied = false
    @State private var resetTask: Task<Void, Never>?

    public init(_ label: String, value: String, copiedLabel: String = "Copiado") {
        self.label = label
        self.value = value
        self.copiedLabel = copiedLabel
    }

    public var body: some View {
        Button(action: copy) {
            HStack(spacing: 6) {
                Text(copied ? copiedLabel : label)
                    .lineLimit(1)
                    .fixedSize()
                    .contentTransition(.opacity)
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
                    .contentTransition(.symbolEffect(.replace))
            }
        }
        .buttonStyle(.mimoPill)
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
