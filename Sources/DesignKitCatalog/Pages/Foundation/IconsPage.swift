//
//  IconsPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct IconsPage: View {
    private let icons: [CatalogOption<Image>] = [
        CatalogOption("tab_item_dashboard", DesignKitIcons.tab_item_dashboard),
        CatalogOption("tab_item_time_sheet", DesignKitIcons.tab_item_time_sheet),
        CatalogOption("tab_item_pay_runs", DesignKitIcons.tab_item_pay_runs),
        CatalogOption("tab_item_commitments", DesignKitIcons.tab_item_commitments),
        CatalogOption("tab_item_profile", DesignKitIcons.tab_item_profile),
    ]

    var body: some View {
        CatalogPage(
            title: "Icons",
            summary: "Custom symbols from IconAssets.xcassets, exposed through DesignKitIcons. They size and color like SF Symbols."
        ) {
            CatalogSection("Icons") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: DKSpacing.sm)], spacing: DKSpacing.sm) {
                    ForEach(icons) { icon in
                        VStack(spacing: DKSpacing.xs) {
                            icon.value
                                .font(.title)
                                .frame(height: 36)
                            Text(icon.name)
                                .font(.system(.caption2, design: .monospaced))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .padding(DKSpacing.sm)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DKRadius.md)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }
                }
            }

            CatalogSection("Usage") {
                CodeSnippet("""
                DesignKitIcons.tab_item_dashboard
                    .font(.title2)
                    .foregroundColor(.accentColor)
                """)
            }
        }
    }
}

#Preview {
    NavigationView { IconsPage() }
}
