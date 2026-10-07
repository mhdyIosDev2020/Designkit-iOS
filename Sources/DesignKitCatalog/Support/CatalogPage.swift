//
//  CatalogPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

/// The scrolling layout every catalog page shares: a short summary at the
/// top, then the page's sections (preview, configuration, code, notes).
struct CatalogPage<Content: View>: View {
    let title: String
    let summary: String
    let content: Content

    init(title: String, summary: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.summary = summary
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DKSpacing.lg) {
                Text(summary)
                    .font(.body)
                    .foregroundColor(.secondary)
                content
            }
            .padding(DKSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(title)
    }
}

/// A titled block inside a `CatalogPage`.
struct CatalogSection<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DKSpacing.sm) {
            Text(title)
                .font(.headline)
            content
        }
    }
}
