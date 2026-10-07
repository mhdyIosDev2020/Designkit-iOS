//
//  CardStackPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct CardStackPage: View {
    @State private var frontIndex = SampleCard.examples.count - 1
    @State private var dragProgress: CGFloat = 0
    @State private var dismissThreshold: CGFloat = 100
    @State private var stackOffset: CGFloat = 20

    var body: some View {
        CatalogPage(
            title: "CardStackView",
            summary: "A stack of cards. Swipe the front card away and it moves to the back. The last item in the list starts on top."
        ) {
            CatalogSection("Preview") {
                ExampleBox {
                    VStack(spacing: DKSpacing.lg) {
                        CardStackView(
                            items: SampleCard.examples.map { $0.cornerRadius(DKRadius.md) },
                            dismissThreshold: dismissThreshold,
                            stackOffsetStep: CGSize(width: stackOffset, height: stackOffset),
                            onFrontChange: { frontIndex = $0 },
                            onDragProgress: { dragProgress = $0 }
                        )
                        .frame(width: 260, height: 170)
                        .padding(.trailing, stackOffset * 2)
                        .padding(.bottom, stackOffset * 2)

                        PageControl(
                            numberOfPages: SampleCard.examples.count,
                            currentPage: frontIndex,
                            dragProgress: dragProgress
                        )
                    }
                    .padding(.vertical, DKSpacing.md)
                }
            }

            CatalogSection("Configuration") {
                ConfigPanel {
                    LabeledSlider(title: "Dismiss threshold", value: $dismissThreshold, range: 40...200)
                    LabeledSlider(title: "Stack offset", value: $stackOffset, range: 0...30)
                }
            }

            CatalogSection("Code") {
                CodeSnippet("""
                CardStackView(
                    items: cards,
                    dismissThreshold: \(Int(dismissThreshold)),
                    stackOffsetStep: CGSize(width: \(Int(stackOffset)), height: \(Int(stackOffset))),
                    onFrontChange: { frontIndex = $0 },
                    onDragProgress: { dragProgress = $0 }
                )
                .frame(width: 260, height: 170)
                """)
            }

            CatalogNote("Feed onDragProgress into PageControl's dragProgress so the dots follow your finger.")
            CatalogNote("The items are copied when the view first appears, so changing the list afterwards has no effect.", isWarning: true)
        }
    }
}

#Preview {
    NavigationView { CardStackPage() }
}
