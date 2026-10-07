//
//  BannerPagingPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct BannerPagingPage: View {
    enum TransformOption: String, CaseIterable, Identifiable {
        case identity, scale, fade

        var id: Self { self }
        var name: String { rawValue.capitalized }

        var transform: (Int) -> CardPageTransform {
            switch self {
            case .identity:
                return { _ in .identity }
            case .scale:
                return { offset in CardPageTransform(scale: offset == 0 ? 1 : 0.9) }
            case .fade:
                return { offset in CardPageTransform(opacity: offset == 0 ? 1 : 0.4) }
            }
        }

        var code: String {
            switch self {
            case .identity:
                return ""
            case .scale:
                return ",\n    transform: { offset in CardPageTransform(scale: offset == 0 ? 1 : 0.9) }"
            case .fade:
                return ",\n    transform: { offset in CardPageTransform(opacity: offset == 0 ? 1 : 0.4) }"
            }
        }
    }

    @State private var page = 0
    @State private var itemWidth: CGFloat = 280
    @State private var itemSpacing: CGFloat = 10
    @State private var cornerRadius: CGFloat = 12
    @State private var transform = TransformOption.identity

    var body: some View {
        CatalogPage(
            title: "BannerPagingView",
            summary: "A swipeable carousel that moves one card at a time. Make the cards narrower than the view to let the next one peek in. Works back to iOS 15."
        ) {
            CatalogSection("Preview") {
                ExampleBox {
                    VStack(spacing: DKSpacing.md) {
                        BannerPagingView(
                            items: SampleCard.examples,
                            itemWidth: itemWidth,
                            itemSpacing: itemSpacing,
                            cornerRadius: cornerRadius,
                            transform: transform.transform,
                            onPageChange: { page = $0 }
                        )
                        .frame(height: 170)

                        PageControl(numberOfPages: SampleCard.examples.count, currentPage: page)
                    }
                }
            }

            CatalogSection("Configuration") {
                ConfigPanel {
                    LabeledSlider(title: "Item width", value: $itemWidth, range: 180...340)
                    LabeledSlider(title: "Item spacing", value: $itemSpacing, range: 0...32)
                    LabeledSlider(title: "Corner radius", value: $cornerRadius, range: 0...24)
                    Text("Transform").font(.subheadline).foregroundColor(.secondary)
                    Picker("Transform", selection: $transform) {
                        ForEach(TransformOption.allCases) { Text($0.name).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
            }

            CatalogSection("Code") {
                CodeSnippet("""
                BannerPagingView(
                    items: cards,
                    itemWidth: \(Int(itemWidth)),
                    itemSpacing: \(Int(itemSpacing)),
                    cornerRadius: \(Int(cornerRadius)),
                    onPageChange: { page = $0 }\(transform.code)
                )
                .frame(height: 170)
                """)
            }

            CatalogNote("Size the view from outside with .frame. Pair it with PageControl to show the current page.")
            CatalogNote("The cards are drawn as one flattened image for smooth swiping, so UIKit-based views (text fields, maps) inside a card won't show.", isWarning: true)
        }
    }
}

#Preview {
    NavigationView { BannerPagingPage() }
}
