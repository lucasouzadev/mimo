import SwiftUI
import MimoDesignSystem

/// Recado, avatar, nome, link público e aniversário.
struct ProfileHeader: View {
    let profile: Profile
    let onEditNote: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            noteBubble
            avatar
            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    Text(profile.name)
                        .mimoFont(.sectionTitle)
                    if let emoji = profile.emoji {
                        Text(emoji).font(.title3)
                    }
                }
                .foregroundStyle(MimoColor.textPrimary)

                MimoCopyButton(profile.displayLink, value: profile.publicURL.absoluteString, copiedLabel: "Link copiado")

                if profile.showsBirthday, let birthday = profile.birthday {
                    Label(birthday.formatted(.dateTime.day().month(.abbreviated)), systemImage: "birthday.cake")
                        .mimoFont(.caption)
                        .foregroundStyle(MimoColor.textPrimary)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 28)
                        .background(MimoColor.fill, in: Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var noteBubble: some View {
        Button(action: onEditNote) {
            Text(profile.note.isEmpty ? "Deixe um recado" : profile.note)
                .mimoFont(.bodySecondary)
                .foregroundStyle(profile.note.isEmpty ? MimoColor.textSecondary : MimoColor.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(MimoColor.surface, in: Capsule())
                .mimoShadow()
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Recado para fãs")
        .accessibilityValue(profile.note.isEmpty ? "Nenhum" : profile.note)
        .accessibilityHint("Toque para editar")
    }

    private var avatar: some View {
        Circle()
            .fill(MimoColor.fill)
            .overlay {
                if let url = profile.avatarURL {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        initials
                    }
                } else {
                    initials
                }
            }
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .overlay(Circle().stroke(MimoColor.surface, lineWidth: 4))
            .mimoShadow()
            .accessibilityHidden(true)
    }

    private var initials: some View {
        Text(profile.initials)
            .mimoFont(.sectionTitle)
            .foregroundStyle(MimoColor.textSecondary)
    }
}
