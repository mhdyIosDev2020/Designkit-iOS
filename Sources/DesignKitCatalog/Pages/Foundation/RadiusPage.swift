//
//  RadiusPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct RadiusPage: View {
    var body: some View {
        CatalogPage(
            title: "Corner radius",
            summary: "DKRadius is the corner radius scale. Use pill for fully rounded ends."
        ) {
            CatalogSection("Scale") {
                ForEach(RadiusOption.allCases) { radius in
                    HStack(spacing: DKSpacing.md) {
                        RoundedRectangle(cornerRadius: radius.value)
                            .fill(Color.accentColor.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: radius.value)
                                    .strokeBorder(Color.accentColor, lineWidth: 1.5)
                            )
                            .frame(width: 120, height: 56)
                        VStack(alignment: .leading) {
                            Text(radius.code)
                                .font(.system(.body, design: .monospaced))
                            Text(radius == .pill ? "fully rounded" : "\(Int(radius.value))pt")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
            }

            CatalogSection("Usage") {
                CodeSnippet("""
                content
                    .background(
                        RoundedRectangle(cornerRadius: DKRadius.md)
                            .fill(Color(.secondarySystemBackground))
                    )
                """)
            }
        }
    }
}

#Preview {
    NavigationView { RadiusPage() }
}
