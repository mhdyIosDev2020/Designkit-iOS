//
//  TypographyPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct TypographyPage: View {
    @State private var size: CGFloat = 17
    @State private var sample = "The quick brown fox"

    private let latoWeights: [CatalogOption<Font.LatoFont>] = [
        CatalogOption("light", .light),
        CatalogOption("regular", .regular),
        CatalogOption("bold", .bold),
        CatalogOption("heavy", .heavy),
        CatalogOption("black", .black),
    ]

    var body: some View {
        CatalogPage(
            title: "Typography",
            summary: "Custom font helpers from Fonts.swift: Lato, Manrope and Roboto."
        ) {
            CatalogSection("Configuration") {
                ConfigPanel {
                    TextField("Sample text", text: $sample)
                        .textFieldStyle(.roundedBorder)
                    LabeledSlider(title: "Size", value: $size, range: 10...40)
                }
            }

            CatalogSection("Lato") {
                ForEach(latoWeights) { weight in
                    VStack(alignment: .leading, spacing: DKSpacing.xxs) {
                        Text(sample)
                            .font(.lato(weight.value, size: size))
                        Text(".lato(.\(weight.name), size: \(Int(size)))")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                }
            }

            CatalogSection("Manrope and Roboto") {
                VStack(alignment: .leading, spacing: DKSpacing.xxs) {
                    Text(sample).font(.manrope(.semibold, size: size))
                    Text(".manrope(.semibold, size: \(Int(size)))")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                VStack(alignment: .leading, spacing: DKSpacing.xxs) {
                    Text(sample).font(.roboto(.semibold, size: size))
                    Text(".roboto(.semibold, size: \(Int(size)))")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                }
            }

            CatalogNote("The font files aren't included in DesignKit yet. Until the app bundles and registers them, every sample here falls back to the system font.", isWarning: true)
            CatalogNote(".manrope(.semibold) and .roboto(.semibold) both ask for a font named \"Semibold\", which doesn't exist. They need real font names, such as \"Manrope-SemiBold\".", isWarning: true)
        }
    }
}

#Preview {
    NavigationView { TypographyPage() }
}
