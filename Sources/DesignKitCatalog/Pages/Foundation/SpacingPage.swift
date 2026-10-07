//
//  SpacingPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct SpacingPage: View {
    private let steps: [CatalogOption<CGFloat>] = [
        CatalogOption("xxs", DKSpacing.xxs),
        CatalogOption("xs", DKSpacing.xs),
        CatalogOption("sm", DKSpacing.sm),
        CatalogOption("md", DKSpacing.md),
        CatalogOption("lg", DKSpacing.lg),
        CatalogOption("xl", DKSpacing.xl),
    ]

    var body: some View {
        CatalogPage(
            title: "Spacing",
            summary: "DKSpacing is the spacing scale, on a 4pt grid. Use it for padding, stack spacing and gaps instead of typing numbers."
        ) {
            CatalogSection("Scale") {
                ForEach(steps) { step in
                    HStack(spacing: DKSpacing.md) {
                        Text("DKSpacing.\(step.name)")
                            .font(.system(.body, design: .monospaced))
                            .frame(width: 150, alignment: .leading)
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: step.value, height: 16)
                        Text("\(Int(step.value))pt")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }

            CatalogSection("Usage") {
                CodeSnippet("""
                VStack(spacing: DKSpacing.sm) {
                    ...
                }
                .padding(DKSpacing.md)
                """)
            }
        }
    }
}

#Preview {
    NavigationView { SpacingPage() }
}
