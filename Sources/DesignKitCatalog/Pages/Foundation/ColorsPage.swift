//
//  ColorsPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct ColorsPage: View {
    private let colors: [CatalogOption<Color>] = [
        CatalogOption("Color.mainText", .mainText),
        CatalogOption("Color.darkPink", .darkPink),
    ]

    var body: some View {
        CatalogPage(
            title: "Colors",
            summary: "Brand colors defined in Colors.swift. Colors from ColorAsset.xcassets switch automatically between light and dark mode."
        ) {
            CatalogSection("Palette") {
                ForEach(colors) { color in
                    HStack(spacing: DKSpacing.md) {
                        RoundedRectangle(cornerRadius: DKRadius.md)
                            .fill(color.value)
                            .frame(width: 64, height: 64)
                            .overlay(
                                RoundedRectangle(cornerRadius: DKRadius.md)
                                    .strokeBorder(Color(.separator), lineWidth: 1)
                            )
                        Text(color.name)
                            .font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                }
            }

            CatalogSection("Usage") {
                CodeSnippet("""
                Text("Hello")
                    .foregroundColor(.mainText)
                """)
            }

            CatalogNote("To add a color that adapts to dark mode, add a color set to ColorAsset.xcassets and expose it in Colors.swift, like mainText.")
            CatalogNote("Color.teal isn't shown: it has the same name as SwiftUI's built-in Color.teal, so apps can't refer to it without an \"ambiguous use\" error. It needs a new name, such as brandTeal.", isWarning: true)
        }
    }
}

#Preview {
    NavigationView { ColorsPage() }
}
