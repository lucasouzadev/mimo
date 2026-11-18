import SwiftUI

public extension View {
    /// Alerta central do Mimo: ícone azul, título, texto, campo opcional
    /// e botões empilhados. O `alert` do sistema não permite este layout.
    ///
    /// Aplique na raiz da tela: o alerta ocupa a área da view onde foi aplicado.
    func mimoAlert(
        isPresented: Binding<Bool>,
        icon: String,
        title: String,
        message: String,
        text: Binding<String>? = nil,
        placeholder: String = "",
        confirmTitle: String = "Salvar",
        cancelTitle: String = "Cancelar",
        onConfirm: @escaping () -> Void
    ) -> some View {
        overlay {
            MimoAlertHost(
                isPresented: isPresented,
                icon: icon,
                title: title,
                message: message,
                text: text,
                placeholder: placeholder,
                confirmTitle: confirmTitle,
                cancelTitle: cancelTitle,
                onConfirm: onConfirm
            )
        }
    }
}

private struct MimoAlertHost: View {
    @Binding var isPresented: Bool
    let icon: String
    let title: String
    let message: String
    let text: Binding<String>?
    let placeholder: String
    let confirmTitle: String
    let cancelTitle: String
    let onConfirm: () -> Void

    @FocusState private var isFieldFocused: Bool

    var body: some View {
        ZStack {
            if isPresented {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture(perform: dismiss)
                    .transition(.opacity)

                card
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.3, bounce: 0.2), value: isPresented)
    }

    private var card: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundStyle(MimoColor.accent)
            Text(title)
                .mimoFont(.body)
                .fontWeight(.semibold)
                .foregroundStyle(MimoColor.textPrimary)
            Text(message)
                .mimoFont(.bodySecondary)
                .foregroundStyle(MimoColor.textSecondary)
                .multilineTextAlignment(.center)

            if let text {
                TextField(placeholder, text: text)
                    .focused($isFieldFocused)
                    .submitLabel(.done)
                    .onSubmit(confirm)
                    .mimoField()
                    .overlay(Capsule().stroke(MimoColor.accent, lineWidth: 2))
                    .padding(.top, 4)
            }

            VStack(spacing: 10) {
                Button(action: confirm) {
                    Label(confirmTitle, systemImage: "checkmark")
                        .labelStyle(TrailingIconLabelStyle())
                }
                .buttonStyle(.mimoNeutral)

                Button(cancelTitle, action: dismiss)
                    .buttonStyle(.mimoSecondary)
            }
            .padding(.top, 4)
        }
        .padding(20)
        .frame(width: MimoMetrics.alertWidth)
        .background(
            MimoColor.surface,
            in: RoundedRectangle(cornerRadius: MimoMetrics.alertRadius, style: .continuous)
        )
        .mimoShadow()
        .accessibilityAddTraits(.isModal)
        .onAppear {
            if text != nil { isFieldFocused = true }
        }
    }

    private func confirm() {
        onConfirm()
        dismiss()
    }

    private func dismiss() {
        isFieldFocused = false
        isPresented = false
    }
}

/// "Salvar ✓": texto primeiro, ícone depois.
private struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.title
            configuration.icon
        }
    }
}
