import SwiftUI
import MimoDesignSystem

/// Recado, avatar, nome, link público e aniversário.
struct ProfileHeader: View {
    let profile: Profile
    let onEditNote: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            avatarWithNote

            VStack(spacing: 10) {
                HStack(spacing: 6) {
                    Text(profile.name)
                        .mimoFont(.profileName)
                    if let emoji = profile.emoji {
                        Text(emoji).font(.title3)
                    }
                }
                .foregroundStyle(MimoColor.textPrimary)

                MimoCopyButton(
                    profile.displayLink,
                    value: profile.publicURL.absoluteString,
                    copiedLabel: "Link copiado",
                    style: .plain
                )

                if profile.showsBirthday, let birthday = profile.birthday {
                    Label(birthday.formatted(.dateTime.day().month(.abbreviated)), systemImage: "birthday.cake")
                        .mimoFont(.body)
                        .foregroundStyle(MimoColor.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Recado + avatar

    /// O balão fica à esquerda do centro e encosta no alto do avatar.
    private var avatarWithNote: some View {
        ZStack(alignment: .top) {
            avatar
                .padding(.top, 32)
            noteBubble
                .offset(x: -27)
        }
    }

    private var noteBubble: some View {
        Button(action: onEditNote) {
            Text(profile.note.isEmpty ? "Deixe um recado" : profile.note)
                .mimoFont(.bodySecondary)
                .foregroundStyle(profile.note.isEmpty ? MimoColor.textSecondary : MimoColor.textPrimary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
                .padding(.top, 9)
                .padding(.bottom, 9 + SpeechBubble.tailHeight)
                .frame(maxWidth: 220)
                .background(SpeechBubble().fill(MimoColor.surface))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Recado para fãs")
        .accessibilityValue(profile.note.isEmpty ? "Nenhum" : profile.note)
        .accessibilityHint("Toque para editar")
    }

    private var avatar: some View {
        Circle()
            .fill(MimoColor.surface)
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
            .mimoShadow()
            .accessibilityHidden(true)
    }

    private var initials: some View {
        Text(profile.initials)
            .mimoFont(.sectionTitle)
            .foregroundStyle(MimoColor.textSecondary)
    }
}

/// Balão de fala: cápsula com uma pontinha curva embaixo.
struct SpeechBubble: Shape {
    static let tailHeight: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let body = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - Self.tailHeight)
        path.addRoundedRect(
            in: body,
            cornerSize: CGSize(width: body.height / 2, height: body.height / 2),
            style: .continuous
        )

        let tailX = rect.midX - 4
        path.move(to: CGPoint(x: tailX - 6, y: body.maxY - 1))
        path.addQuadCurve(
            to: CGPoint(x: tailX + 2, y: rect.maxY),
            control: CGPoint(x: tailX - 3, y: body.maxY + 3)
        )
        path.addQuadCurve(
            to: CGPoint(x: tailX + 8, y: body.maxY - 1),
            control: CGPoint(x: tailX + 5, y: body.maxY + 4)
        )
        path.closeSubpath()
        return path
    }
}
