import Foundation

public extension ProfileModel {
    /// Dados de exemplo para previews e para a primeira versão do app.
    static func sample() -> ProfileModel {
        let birthday = Calendar.current.date(from: DateComponents(year: 1998, month: 1, day: 21))

        let profile = Profile(
            name: "Luca Souza",
            emoji: "✨",
            handle: "lucasouza",
            birthday: birthday,
            note: "Olá!"
        )

        let wishes: [Wish] = [
            Wish(name: "Fone sem fio com cancelamento de ruído", price: 2499, aspectRatio: 0.85,
                 placeholderSymbol: "headphones", placeholderTint: 0xE4E1DA, isPinned: true),
            Wish(name: "Viagem de fim de semana para a praia", price: 3000, aspectRatio: 0.7,
                 placeholderSymbol: "beach.umbrella", placeholderTint: 0xD9E6EC,
                 isCrowdfunding: true, raised: 1100),
            Wish(name: "Vaso de cerâmica pintado à mão", price: 380, aspectRatio: 0.75,
                 placeholderSymbol: "camera.macro", placeholderTint: 0xEADCCB),
            Wish(name: "Câmera instantânea", price: 699, aspectRatio: 1,
                 placeholderSymbol: "camera", placeholderTint: 0xF0E2E2),
            Wish(name: "Tênis de corrida", price: 899, aspectRatio: 1.1,
                 placeholderSymbol: "shoe", placeholderTint: 0xE2E7DD),
            Wish(name: "Kit de pincéis para aquarela", price: 210, aspectRatio: 0.8,
                 placeholderSymbol: "paintbrush.pointed", placeholderTint: 0xE7E0EE),
            Wish(name: "Luminária de mesa articulada", price: 450, aspectRatio: 0.72,
                 placeholderSymbol: "lamp.desk", placeholderTint: 0xF1E6CF),
            Wish(name: "Livro de receitas de massas", price: 129, aspectRatio: 0.78,
                 placeholderSymbol: "book.closed", placeholderTint: 0xEBDDD3),
            Wish(name: "Fone com fio", price: 199, aspectRatio: 0.9,
                 placeholderSymbol: "earbuds", placeholderTint: 0xE4E1DA,
                 isArchived: true, raised: 60)
        ]

        let checklist: [ChecklistStep] = [
            ChecklistStep(id: "socials", icon: "at", title: "Redes adicionadas",
                          message: "Seus fãs sabem onde te encontrar.", buttonTitle: "Adicionar redes", isDone: true),
            ChecklistStep(id: "share", icon: "square.and.arrow.up", title: "Compartilhe sua lista",
                          message: "Coloque o link na bio para seus fãs te mimarem.", buttonTitle: "Compartilhar"),
            ChecklistStep(id: "wishes", icon: "gift", title: "Desejos adicionados",
                          message: "Sua lista já tem o que você quer ganhar.", buttonTitle: "Adicionar desejos", isDone: true),
            ChecklistStep(id: "profile", icon: "person.crop.circle", title: "Foto e nome definidos",
                          message: "Agora fica muito mais fácil ser mimado!", buttonTitle: "Editar perfil", isDone: true),
            ChecklistStep(id: "payouts", icon: "dollarsign.circle.fill", title: "Configure os recebimentos",
                          message: "Ninguém consegue te presentear até você configurar os recebimentos.",
                          buttonTitle: "Conectar conta")
        ]

        return ProfileModel(profile: profile, wishes: wishes, checklist: checklist)
    }
}
