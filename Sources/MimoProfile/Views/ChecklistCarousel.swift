import SwiftUI
import MimoDesignSystem

/// "Ative sua lista": cartões paginados com pontos indicadores.
struct ChecklistCarousel: View {
    let steps: [ChecklistStep]
    let pendingSteps: Int
    let onAction: (ChecklistStep) -> Void

    @State private var currentID: ChecklistStep.ID?

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Ative sua lista")
                    .mimoFont(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(MimoColor.textPrimary)
                Spacer()
                Text(pendingSteps == 1 ? "última etapa" : "faltam \(pendingSteps)")
                    .mimoFont(.bodySecondary)
                    .fontWeight(.semibold)
                    .foregroundStyle(MimoColor.textSecondary)
                    .padding(.horizontal, 12)
                    .frame(minHeight: 30)
                    .background(MimoColor.fill, in: Capsule())
            }
            .padding(.horizontal, MimoMetrics.screenPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(steps) { step in
                        MimoActionCard(
                            icon: step.icon,
                            title: step.title,
                            message: step.message,
                            buttonTitle: step.buttonTitle,
                            isDone: step.isDone
                        ) {
                            onAction(step)
                        }
                        .containerRelativeFrame(.horizontal) { width, _ in
                            width - MimoMetrics.screenPadding * 2
                        }
                        .id(step.id)
                    }
                }
                .scrollTargetLayout()
                .padding(.vertical, 12)
            }
            .contentMargins(.horizontal, MimoMetrics.screenPadding, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $currentID)

            pageDots
        }
        .onAppear {
            if currentID == nil {
                currentID = steps.first(where: { !$0.isDone })?.id ?? steps.first?.id
            }
        }
    }

    private var pageDots: some View {
        HStack(spacing: 6) {
            ForEach(steps) { step in
                Circle()
                    .fill(step.id == currentID ? MimoColor.textPrimary : MimoColor.textSecondary.opacity(0.35))
                    .frame(width: 6, height: 6)
            }
        }
        .animation(.snappy, value: currentID)
        .accessibilityHidden(true)
    }
}
