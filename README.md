# Mimo — Design System

Biblioteca de componentes SwiftUI do **Mimo**, um app de lista de desejos pública: o criador monta a lista, publica o link e os fãs presenteiam, inteiro ou em vaquinha.

Este pacote contém só a camada visual (tokens, modificadores e componentes). As telas do app são montadas em cima dele.

## Compatibilidade

| | |
| --- | --- |
| Mínimo | **iOS 18** |
| Visual completo | **iOS 26+** (Liquid Glass) |
| Xcode | 26 ou posterior (é preciso o SDK do iOS 26 para compilar `glassEffect`) |

O iOS 18 roda nos mesmos iPhones que o 17 (XS/XR em diante), então baixar o mínimo para o 17 não ganharia nenhum aparelho.

Toda checagem de versão fica dentro do design system:

- `View.mimoGlass(in:)`: Liquid Glass no iOS 26+; material translúcido com borda fina no iOS 18.
- `MimoTabContainer`: `TabView` nativo no iOS 26+; pílula flutuante própria no iOS 18.

As telas não testam a versão do iOS.

## Estrutura

```
Sources/MimoDesignSystem/
├── Tokens/        MimoColor, MimoTypography (mimoFont), MimoMetrics (mimoShadow)
├── Modifiers/     mimoBackground, mimoDarkBackground, mimoGlass
├── Components/    botões, cartão de produto, campos, chips, toggle,
│                  barra de progresso, cartão de ação, linha de preferência,
│                  estado vazio, botão de copiar, alerta, contêiner de abas
└── Previews/      MimoGallery: catálogo para o Canvas do Xcode
```

## Uso

```swift
import MimoDesignSystem

struct WishDetail: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Fone sem fio").mimoFont(.collectionTitle)
                MimoProgressBar(value: 0.62, leadingLabel: "62% arrecadado", trailingLabel: "Meta R$ 2.499")
            }
            .padding(MimoMetrics.screenPadding)
        }
        .mimoBackground()
        .safeAreaInset(edge: .bottom) {
            Button("Presentear") {}
                .buttonStyle(.mimoPrimary)
                .padding(.horizontal, MimoMetrics.screenPadding)
        }
    }
}
```

## Princípios

1. Um fundo só, creme e contínuo; nada de barras opacas ou divisórias.
2. Serifa para emoção (títulos, valores, estados vazios), sans para função.
3. Branco significa "toque aqui"; bege é secundário.
4. Azul só para ação e progresso.
5. Tudo é cápsula ou cartão muito arredondado.
6. Sheets, menus e seletores são os do sistema.

O spec completo de UI/UX (telas, navegação, microinterações) está no documento do projeto.

## Próximos passos

- [ ] Abas de segmento (Preferências) e cabeçalho de coleção
- [ ] Grade em alvenaria para a lista do perfil
- [ ] Avatar do usuário como ícone da aba Perfil
- [ ] Testes de snapshot dos componentes nos dois visuais (iOS 18 e 26)
