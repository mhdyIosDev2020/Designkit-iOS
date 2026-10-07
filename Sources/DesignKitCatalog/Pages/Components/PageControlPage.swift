//
//  PageControlPage.swift
//  DesignKitCatalog
//

import SwiftUI
import DesignKit

struct PageControlPage: View {
    @State private var numberOfPages = 5
    @State private var currentPage = 0
    @State private var dragProgress: CGFloat = 0
    @State private var dotSize: CGFloat = 8
    @State private var spacing: CGFloat = 8
    @State private var activeColor = ColorOption.primary

    var body: some View {
        CatalogPage(
            title: "PageControl",
            summary: "Dots that show the current page. The active dot stretches into a pill. It only displays the position; it doesn't change pages itself."
        ) {
            CatalogSection("Preview") {
                ExampleBox {
                    PageControl(
                        numberOfPages: numberOfPages,
                        currentPage: currentPage,
                        dragProgress: dragProgress,
                        activeColor: activeColor.value,
                        dotSize: dotSize,
                        spacing: spacing
                    )
                    .padding(.vertical, DKSpacing.lg)
                }
            }

            CatalogSection("Configuration") {
                ConfigPanel {
                    Stepper("Pages: \(numberOfPages)", value: $numberOfPages, in: 2...8)
                    Stepper("Current page: \(currentPage)", value: $currentPage, in: 0...(numberOfPages - 1))
                    LabeledSlider(title: "Drag progress", value: $dragProgress, range: -1...1, step: 0.05)
                    LabeledSlider(title: "Dot size", value: $dotSize, range: 4...16)
                    LabeledSlider(title: "Spacing", value: $spacing, range: 2...20)
                    HStack {
                        Text("Active color")
                        Spacer()
                        Picker("Active color", selection: $activeColor) {
                            ForEach(ColorOption.allCases) { Text($0.name).tag($0) }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }

            CatalogSection("Code") {
                CodeSnippet("""
                PageControl(
                    numberOfPages: \(numberOfPages),
                    currentPage: currentPage,
                    dragProgress: dragProgress,
                    activeColor: \(activeColor.code),
                    dotSize: \(Int(dotSize)),
                    spacing: \(Int(spacing))
                )
                """)
            }

            CatalogNote("Drag progress runs from -1 (toward the previous page) to 1 (toward the next). In an app it comes from CardStackView's onDragProgress.")
        }
        .onChange(of: numberOfPages) { pages in
            currentPage = min(currentPage, pages - 1)
        }
    }
}

#Preview {
    NavigationView { PageControlPage() }
}
